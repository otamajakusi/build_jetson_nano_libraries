#!/usr/bin/env bash

set -eux

# 1
if [ -e .phase ] && [ $(cat .phase) -lt 1 ]; then
apt-get update
apt-get install -y \
      python3.8 python3.8-dev \
      ninja-build git cmake clang \
      libopenmpi-dev libomp-dev ccache \
      libopenblas-dev libblas-dev libeigen3-dev \
      python3-pip libjpeg-dev \
      gnupg2 curl
echo -n 1 > .phase
fi

# 2
if [ -e .phase ] && [ $(cat .phase) -lt 2 ]; then
apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
echo -e 'deb https://repo.download.nvidia.com/jetson/common r32.7 main\ndeb https://repo.download.nvidia.com/jetson/t210 r32.7 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

# cuda and cudnn
apt-get update && apt-get install -y nvidia-cuda nvidia-cudnn8
echo -n 2 > .phase
fi

# 3
if [ -e .phase ] && [ $(cat .phase) -lt 3 ]; then
# cmake
apt-get install -y software-properties-common lsb-release
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
apt-get update && apt-get install -y cmake
echo -n 3 > .phase
fi

# 4
if [ -e .phase ] && [ $(cat .phase) -lt 4 ]; then
python3.8 -m pip install -U pip
python3.8 -m pip install -U setuptools
python3.8 -m pip install -U wheel mock pillow
python3.8 -m pip install scikit-build
python3.8 -m pip install cython Pillow
echo -n 4 > .phase
fi

# 5
if [ -e .phase ] && [ $(cat .phase) -lt 5 ]; then
## download PyTorch v1.11.0 with all its libraries
git clone -b v1.11.0 --depth 1 --recursive --recurse-submodules --shallow-submodules https://github.com/pytorch/pytorch.git
(
cd pytorch
python3.8 -m pip install -r requirements.txt
patch -p1 < ../pytorch-1.11-jetson.patch
)
echo -n 5 > .phase
fi

# 6
if [ -e .phase ] && [ $(cat .phase) -lt 6 ]; then
export BUILD_CAFFE2_OPS=OFF
export USE_FBGEMM=OFF
export USE_FAKELOWP=OFF
export BUILD_TEST=OFF
export USE_MKLDNN=OFF
export USE_NNPACK=OFF
export USE_XNNPACK=OFF
export USE_QNNPACK=OFF
export USE_PYTORCH_QNNPACK=OFF
export USE_CUDA=ON
export USE_CUDNN=ON
export TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2"
export USE_NCCL=OFF
export USE_SYSTEM_NCCL=OFF
export USE_OPENCV=OFF
export MAX_JOBS=${MAX_JOBS:-2}
# set path to ccache
export PATH=/usr/lib/ccache:/usr/local/cuda/bin:$PATH
# set clang compiler
export CC=clang
export CXX=clang++
# create symlink to cublas
# ln -s /usr/lib/aarch64-linux-gnu/libcublas.so /usr/local/cuda/lib64/libcublas.so
# start the build
(
cd pytorch
python3.8 setup.py bdist_wheel
)
echo -n 6 > .phase
fi

# 7
if [ -e .phase ] && [ $(cat .phase) -lt 7 ]; then
# torch vision
git clone --depth=1 https://github.com/pytorch/vision torchvision -b v0.12.0
(
cd torchvision && \
  export TORCH_CUDA_ARCH_LIST='5.3;6.2;7.2' \
  export FORCE_CUDA=1 \
  python3.8 setup.py install && setup.py bdist_wheel
)
echo -n 7 > .phase
fi
