#!/bin/sh

set -e

. $(dirname $0)/env.sh

mkdir -p dist

for TARGETARCH in arm64 amd64; do
    echo "Building Go runner darwin $TARGETARCH"
    rm -rf llama/build
    GOOS=darwin ARCH=$TARGETARCH GOARCH=$TARGETARCH make -C llama -j 8
    # These require Xcode v13 or older to target MacOS v11
    # If installed to an alternate location use the following to enable
    # export SDKROOT=/Applications/Xcode_12.5.1.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    # export DEVELOPER_DIR=/Applications/Xcode_12.5.1.app/Contents/Developer
    export CGO_CFLAGS=-mmacosx-version-min=11.3
    export CGO_CXXFLAGS=-mmacosx-version-min=11.3
    export CGO_LDFLAGS=-mmacosx-version-min=11.3
    CGO_ENABLED=1 GOOS=darwin GOARCH=$TARGETARCH go build -trimpath -o dist/unieai-darwin-$TARGETARCH
    CGO_ENABLED=1 GOOS=darwin GOARCH=$TARGETARCH go build -trimpath -cover -o dist/unieai-darwin-$TARGETARCH-cov
done

lipo -create -output dist/unieai dist/unieai-darwin-arm64 dist/unieai-darwin-amd64
rm -f dist/unieai-darwin-arm64 dist/unieai-darwin-amd64
if [ -n "$APPLE_IDENTITY" ]; then
    codesign --deep --force --options=runtime --sign "$APPLE_IDENTITY" --timestamp dist/unieai
else
    echo "Skipping code signing - set APPLE_IDENTITY"
fi
chmod +x dist/unieai

# build and optionally sign the mac app
npm install --prefix macapp
if [ -n "$APPLE_IDENTITY" ]; then
    npm run --prefix macapp make:sign
else
    npm run --prefix macapp make
fi
cp macapp/out/make/zip/darwin/universal/Unieai-darwin-universal-$VERSION.zip dist/Unieai-darwin.zip

# sign the binary and rename it
if [ -n "$APPLE_IDENTITY" ]; then
    codesign -f --timestamp -s "$APPLE_IDENTITY" --identifier ai.unieai.unieai --options=runtime dist/unieai
else
    echo "WARNING: Skipping code signing - set APPLE_IDENTITY"
fi
ditto -c -k --keepParent dist/unieai dist/temp.zip
if [ -n "$APPLE_IDENTITY" ]; then
    xcrun notarytool submit dist/temp.zip --wait --timeout 10m --apple-id $APPLE_ID --password $APPLE_PASSWORD --team-id $APPLE_TEAM_ID
fi
mv dist/unieai dist/unieai-darwin
rm -f dist/temp.zip
