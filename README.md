# This repository

This repository is for building Jetson Nano libraries for python3.8.

The following libraries can be supported:

- PyTorch(v1.11.0 with TorchVision(v0.12.0))
- OpenCV(v4.6.0)

# Build

There are two types of build script. One is a native bash script, the other is
dockerfile build script. The native bash script can be run on the Jetson Nano.
The dockerfile build script can be run on the Jetson Nano and also can be run
on the host PC. Before running dockerfile on the host PC, qemu-user-static
libray should be installed.

# script layout

```
.
├── pytorch
│    ├── build_native.sh
│    ├── build_docker.sh
│    └── Dockerfile
└── opencv
     ├── build_native.sh
     ├── build_docker.sh
     └── Dockerfile
```

# Performance


# Reference
- https://qengineering.eu/install-pytorch-on-jetson-nano.html
- http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_python_3_7_10/
- https://github.com/mdegans/nano_build_opencv (opencv/build_native.sh is almost same as this repository)
