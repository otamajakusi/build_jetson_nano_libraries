# This repository

Tsis repository is for building Jetson Nano libraries for python3.8.

The following libraries can be supported:

- PyTorch(v1.11.0 with TorchVision(v0.12.0))
- OpenCV(v4.6.0)

# Build

There are 2 types of build script. One is a native bash script, the other is dockerfile.
The native bash script can be run on the Jetson Nano.
The dockerfile can be run on the Jetson Nano and also can be run on the host pc. Before running dockerfile, qemu-user-static libray should be installed on the host pc.

# script layout

```
pytorch/build_native.sh
       /build_docker.sh
       /Dockerfile
opencv/build.sh
      /build_docker.sh
      /Dockerfile
```

# Reference
- https://qengineering.eu/install-pytorch-on-jetson-nano.html
- http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_python_3_7_10/
