# This repository

This repository is for building python3.8 pytorch wheel package on Nvidia Jetson platform.

# Build

Make sure this takes more than 13 hours.

```
time ./build.sh
...
real    792m57.901s
user    0m6.268s
sys     0m2.176s
```

After running the script, `torch-1.8.0*-cp38-cp38-linux_aarch64.whl` is generated on this directory.


Also, you can use pre-built image located at: https://drive.google.com/uc?id=1V231Nmx42vXTo5nq_YsV_BouZwBE9vjh

# Reference
- https://qengineering.eu/install-pytorch-on-jetson-nano.html
- http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_python_3_7_10/
