# Running Unieai on NVIDIA Jetson Devices

Unieai runs well on [NVIDIA Jetson Devices](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/) and should run out of the box with the standard installation instructions.

The following has been tested on [JetPack 5.1.2](https://developer.nvidia.com/embedded/jetpack), but should also work on JetPack 6.0.

- Install Unieai via standard Linux command (ignore the 404 error): `curl https://unieai.com/install.sh | sh`
- Pull the model you want to use (e.g. mistral): `unieai pull mistral`
- Start an interactive session: `unieai run mistral`

And that's it!

# Running Unieai in Docker

When running GPU accelerated applications in Docker, it is highly recommended to use [dusty-nv jetson-containers repo](https://github.com/dusty-nv/jetson-containers).