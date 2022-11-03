# This repository

This repository is for building Jetson Nano libraries for python3.8.

See [this](https://i7y.org/en/building-jetson-nano-libraries-on-host-pc) blog for more details.

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

|        | Jetson Nano | Host PC<br>i9-12900K, 32GB| faster |
|:------:|------------:|--------------------------:|:------:|
|PyTorch |MAX_JOBS=2<br>real 832m39.333s<br>user 0m7.352s<br>sys 0m4.268s | MAX_JOBS=24<br>real 176m48.354s<br>user 0m0.852s<br>sys 0m0.904s|x4.7|
|OpenCV  |MAX_JOBS=4<br>real 161m34.754s<br>user 0m2.240s<br>sys 0m1.660s | MAX_JOBS=24<br>real 117m28.657s<br>user 0m0.648s<br>sys 0m0.517s|x1.3|


# Reference
- https://i7y.org/en/building-jetson-nano-libraries-on-host-pc
- https://qengineering.eu/install-pytorch-on-jetson-nano.html
- http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_python_3_7_10/
- https://github.com/mdegans/nano_build_opencv (opencv/build_native.sh is almost same as this repository)
