# Linux

## Install

To install Unieai, run the following command:

```shell
curl -fsSL https://unieai.com/install.sh | sh
```

## Manual install

Download and extract the package:

```shell
curl -L https://unieai.com/download/unieai-linux-amd64.tgz -o unieai-linux-amd64.tgz
sudo tar -C /usr -xzf unieai-linux-amd64.tgz
```

Start Unieai:

```shell
unieai serve
```

In another terminal, verify that Unieai is running:

```shell
unieai -v
```

### AMD GPU install

If you have an AMD GPU, also download and extract the additional ROCm package:

```shell
curl -L https://unieai.com/download/unieai-linux-amd64-rocm.tgz -o unieai-linux-amd64-rocm.tgz
sudo tar -C /usr -xzf unieai-linux-amd64-rocm.tgz
```

### ARM64 install

Download and extract the ARM64-specific package:

```shell
curl -L https://unieai.com/download/unieai-linux-arm64.tgz -o unieai-linux-arm64.tgz
sudo tar -C /usr -xzf unieai-linux-arm64.tgz
```

### Adding Unieai as a startup service (recommended)

Create a user and group for Unieai:

```shell
sudo useradd -r -s /bin/false -U -m -d /usr/share/unieai unieai
sudo usermod -a -G unieai $(whoami)
```

Create a service file in `/etc/systemd/system/unieai.service`:

```ini
[Unit]
Description=Unieai Service
After=network-online.target

[Service]
ExecStart=/usr/bin/unieai serve
User=unieai
Group=unieai
Restart=always
RestartSec=3
Environment="PATH=$PATH"

[Install]
WantedBy=default.target
```

Then start the service:

```shell
sudo systemctl daemon-reload
sudo systemctl enable unieai
```

### Install CUDA drivers (optional)

[Download and install](https://developer.nvidia.com/cuda-downloads) CUDA.

Verify that the drivers are installed by running the following command, which should print details about your GPU:

```shell
nvidia-smi
```

### Install AMD ROCm drivers (optional)

[Download and Install](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/tutorial/quick-start.html) ROCm v6.

### Start Unieai

Start Unieai and verify it is running:

```shell
sudo systemctl start unieai
sudo systemctl status unieai
```

> [!NOTE]
> While AMD has contributed the `amdgpu` driver upstream to the official linux
> kernel source, the version is older and may not support all ROCm features. We
> recommend you install the latest driver from
> https://www.amd.com/en/support/linux-drivers for best support of your Radeon
> GPU.

## Updating

Update Unieai by running the install script again:

```shell
curl -fsSL https://unieai.com/install.sh | sh
```

Or by re-downloading Unieai:

```shell
curl -L https://unieai.com/download/unieai-linux-amd64.tgz -o unieai-linux-amd64.tgz
sudo tar -C /usr -xzf unieai-linux-amd64.tgz
```

## Installing specific versions

Use `UNIEAI_VERSION` environment variable with the install script to install a specific version of Unieai, including pre-releases. You can find the version numbers in the [releases page](https://github.com/nctu6/unieai/releases).

For example:

```shell
curl -fsSL https://unieai.com/install.sh | UNIEAI_VERSION=0.3.9 sh
```

## Viewing logs

To view logs of Unieai running as a startup service, run:

```shell
journalctl -e -u unieai
```

## Uninstall

Remove the unieai service:

```shell
sudo systemctl stop unieai
sudo systemctl disable unieai
sudo rm /etc/systemd/system/unieai.service
```

Remove the unieai binary from your bin directory (either `/usr/local/bin`, `/usr/bin`, or `/bin`):

```shell
sudo rm $(which unieai)
```

Remove the downloaded models and Unieai service user and group:

```shell
sudo rm -r /usr/share/unieai
sudo userdel unieai
sudo groupdel unieai
```
