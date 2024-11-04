#!powershell
#
# powershell -ExecutionPolicy Bypass -File .\scripts\build_windows.ps1
#
# gcloud auth application-default login

$ErrorActionPreference = "Stop"

function checkEnv() {
    if ($null -ne $env:ARCH ) {
        $script:ARCH = $env:ARCH
    } else {
        $arch=([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)
        if ($null -ne $arch) {
            $script:ARCH = ($arch.ToString().ToLower()).Replace("x64", "amd64")
        } else {
            write-host "WARNING: old powershell detected, assuming amd64 architecture - set `$env:ARCH to override"
            $script:ARCH="amd64"
        }
    }
    $script:TARGET_ARCH=$script:ARCH
    Write-host "Building for ${script:TARGET_ARCH}"
    write-host "Locating required tools and paths"
    $script:SRC_DIR=$PWD
    if ($null -eq $env:VCToolsRedistDir) {
        $MSVC_INSTALL=(Get-CimInstance MSFT_VSInstance -Namespace root/cimv2/vs)[0].InstallLocation
        $env:VCToolsRedistDir=(get-item "${MSVC_INSTALL}\VC\Redist\MSVC\*")[0]
    }
    # Locate CUDA versions
    # Note: this assumes every version found will be built
    $cudaList=(get-item "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v*\bin\" -ea 'silentlycontinue')
    if ($cudaList.length -eq 0) {
        $d=(get-command -ea 'silentlycontinue' nvcc).path
        if ($null -ne $d) {
            $script:CUDA_DIRS=@($d| split-path -parent)
        }
    } else {
        $script:CUDA_DIRS=$cudaList
    }

    $inoSetup=(get-item "C:\Program Files*\Inno Setup*\")
    if ($inoSetup.length -gt 0) {
        $script:INNO_SETUP_DIR=$inoSetup[0]
    }

    $script:DIST_DIR="${script:SRC_DIR}\dist\windows-${script:TARGET_ARCH}"
    $env:CGO_ENABLED="1"
    Write-Output "Checking version"
    if (!$env:VERSION) {
        $data=(git describe --tags --first-parent --abbrev=7 --long --dirty --always)
        $pattern="v(.+)"
        if ($data -match $pattern) {
            $script:VERSION=$matches[1]
        }
    } else {
        $script:VERSION=$env:VERSION
    }
    $pattern = "(\d+[.]\d+[.]\d+).*"
    if ($script:VERSION -match $pattern) {
        $script:PKG_VERSION=$matches[1]
    } else {
        $script:PKG_VERSION="0.0.0"
    }
    write-host "Building Unieai $script:VERSION with package version $script:PKG_VERSION"

    # Note: Windows Kits 10 signtool crashes with GCP's plugin
    if ($null -eq $env:SIGN_TOOL) {
        ${script:SignTool}="C:\Program Files (x86)\Windows Kits\8.1\bin\x64\signtool.exe"
    } else {
        ${script:SignTool}=${env:SIGN_TOOL}
    }
    if ("${env:KEY_CONTAINER}") {
        ${script:unieai_CERT}=$(resolve-path "${script:SRC_DIR}\unieai_inc.crt")
        Write-host "Code signing enabled"
    } else {
        write-host "Code signing disabled - please set KEY_CONTAINERS to sign and copy unieai_inc.crt to the top of the source tree"
    }
}


function buildUnieai() {
    if ($null -eq ${env:unieai_SKIP_GENERATE}) {
        write-host "Building unieai runners"
        Remove-Item -ea 0 -recurse -force -path "${script:SRC_DIR}\dist\windows-${script:ARCH}"
        & make -C llama -j 12
        if ($LASTEXITCODE -ne 0) { exit($LASTEXITCODE)}
    } else {
        write-host "Skipping generate step with unieai_SKIP_GENERATE set"
    }
    write-host "Building unieai CLI"
    & go build -trimpath -ldflags "-s -w -X=github.com/nctu6/unieai/version.Version=$script:VERSION -X=github.com/nctu6/unieai/server.mode=release" .
    if ($LASTEXITCODE -ne 0) { exit($LASTEXITCODE)}
    New-Item -ItemType Directory -Path .\dist\windows-${script:TARGET_ARCH}\ -Force
    cp .\unieai.exe .\dist\windows-${script:TARGET_ARCH}\
}

function buildApp() {
    write-host "Building Unieai App"
    cd "${script:SRC_DIR}\app"
    & windres -l 0 -o unieai.syso unieai.rc
    & go build -trimpath -ldflags "-s -w -H windowsgui -X=github.com/nctu6/unieai/version.Version=$script:VERSION -X=github.com/nctu6/unieai/server.mode=release" -o "${script:SRC_DIR}\dist\windows-${script:TARGET_ARCH}-app.exe" .
    if ($LASTEXITCODE -ne 0) { exit($LASTEXITCODE)}
}

function gatherDependencies() {
    if ($null -eq $env:VCToolsRedistDir) {
        write-error "Unable to locate VC Install location - please use a Developer shell"
        exit 1
    }
    write-host "Gathering runtime dependencies from $env:VCToolsRedistDir"
    cd "${script:SRC_DIR}"
    md "${script:DIST_DIR}\lib\unieai" -ea 0 > $null

    # TODO - this varies based on host build system and MSVC version - drive from dumpbin output
    # currently works for Win11 + MSVC 2019 + Cuda V11
    if ($script:TARGET_ARCH -eq "amd64") {
        $depArch="x64"
    } else {
        $depArch=$script:TARGET_ARCH
    }
    if ($depArch -eq "x64") {
        cp "${env:VCToolsRedistDir}\${depArch}\Microsoft.VC*.CRT\msvcp140*.dll" "${script:DIST_DIR}\lib\unieai\"
        cp "${env:VCToolsRedistDir}\${depArch}\Microsoft.VC*.CRT\vcruntime140.dll" "${script:DIST_DIR}\lib\unieai\"
        cp "${env:VCToolsRedistDir}\${depArch}\Microsoft.VC*.CRT\vcruntime140_1.dll" "${script:DIST_DIR}\lib\unieai\"
        $llvmCrtDir="$env:VCToolsRedistDir\..\..\..\Tools\Llvm\${depArch}\bin"
        foreach ($part in $("runtime", "stdio", "filesystem", "math", "convert", "heap", "string", "time", "locale", "environment")) {
            write-host "cp ${llvmCrtDir}\api-ms-win-crt-${part}*.dll ${script:DIST_DIR}\lib\unieai\"
            cp "${llvmCrtDir}\api-ms-win-crt-${part}*.dll" "${script:DIST_DIR}\lib\unieai\"
        }
    } else {
        # Carying the dll's doesn't seem to work, so use the redist installer
        copy-item -path "${env:VCToolsRedistDir}\vc_redist.arm64.exe" -destination "${script:DIST_DIR}" -verbose
    }

    cp "${script:SRC_DIR}\app\unieai_welcome.ps1" "${script:SRC_DIR}\dist\"
}

function sign() {
    if ("${env:KEY_CONTAINER}") {
        write-host "Signing Unieai executables, scripts and libraries"
        & "${script:SignTool}" sign /v /fd sha256 /t http://timestamp.digicert.com /f "${script:unieai_CERT}" `
            /csp "Google Cloud KMS Provider" /kc ${env:KEY_CONTAINER} `
            $(get-childitem -path "${script:SRC_DIR}\dist" -r -include @('unieai_welcome.ps1')) `
            $(get-childitem -path "${script:SRC_DIR}\dist\windows-*" -r -include @('*.exe', '*.dll'))
        if ($LASTEXITCODE -ne 0) { exit($LASTEXITCODE)}
    } else {
        write-host "Signing not enabled"
    }
}

function buildInstaller() {
    if ($null -eq ${script:INNO_SETUP_DIR}) {
        write-host "Inno Setup not present, skipping installer build"
        return
    }
    write-host "Building Unieai Installer"
    cd "${script:SRC_DIR}\app"
    $env:PKG_VERSION=$script:PKG_VERSION
    if ("${env:KEY_CONTAINER}") {
        & "${script:INNO_SETUP_DIR}\ISCC.exe" /DARCH=$script:TARGET_ARCH /SMySignTool="${script:SignTool} sign /fd sha256 /t http://timestamp.digicert.com /f ${script:unieai_CERT} /csp `$qGoogle Cloud KMS Provider`$q /kc ${env:KEY_CONTAINER} `$f" .\unieai.iss
    } else {
        & "${script:INNO_SETUP_DIR}\ISCC.exe" /DARCH=$script:TARGET_ARCH .\unieai.iss
    }
    if ($LASTEXITCODE -ne 0) { exit($LASTEXITCODE)}
}

function distZip() {
    write-host "Generating stand-alone distribution zip file ${script:SRC_DIR}\dist\unieai-windows-${script:TARGET_ARCH}.zip"
    Compress-Archive -Path "${script:SRC_DIR}\dist\windows-${script:TARGET_ARCH}\*" -DestinationPath "${script:SRC_DIR}\dist\unieai-windows-${script:TARGET_ARCH}.zip" -Force
}

checkEnv
try {
    if ($($args.count) -eq 0) {
        buildUnieai
        buildApp
        gatherDependencies
        sign
        buildInstaller
        distZip
    } else {
        for ( $i = 0; $i -lt $args.count; $i++ ) {
            write-host "performing $($args[$i])"
            & $($args[$i])
        }
    }
} catch {
    write-host "Build Failed"
    write-host $_
} finally {
    set-location $script:SRC_DIR
    $env:PKG_VERSION=""
}
