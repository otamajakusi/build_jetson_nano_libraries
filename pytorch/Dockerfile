FROM nvcr.io/nvidia/l4t-base:r32.7.1
ENV DEBIAN_FRONTEND=noninteractive
ARG MAX_JOBS=2

# https://qengineering.eu/install-pytorch-on-jetson-nano.html
RUN apt-get update && apt-get install -y \
      python3.8 python3.8-dev \
      ninja-build git cmake clang \
      libopenmpi-dev libomp-dev ccache \
      libopenblas-dev libblas-dev libeigen3-dev \
      python3-pip libjpeg-dev \
      gnupg2 curl

RUN apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN echo 'deb https://repo.download.nvidia.com/jetson/common r32.7 main\n\
deb https://repo.download.nvidia.com/jetson/t210 r32.7 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

RUN apt-get update && apt-get install -y nvidia-cuda nvidia-cudnn8
RUN python3.8 -m pip install -U pip
RUN python3.8 -m pip install -U setuptools
RUN python3.8 -m pip install -U wheel mock pillow
RUN python3.8 -m pip install scikit-build
RUN python3.8 -m pip install cython Pillow
## download PyTorch v1.11.0 with all its libraries
RUN git clone -b v1.11.0 --depth 1 --recursive --recurse-submodules --shallow-submodules https://github.com/pytorch/pytorch.git
WORKDIR pytorch
RUN python3.8 -m pip install -r requirements.txt
COPY pytorch-1.11-jetson.patch .
RUN patch -p1 < pytorch-1.11-jetson.patch

RUN apt-get install -y software-properties-common lsb-release
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt-get update && apt-get install -y cmake

ENV BUILD_CAFFE2_OPS=OFF
ENV USE_FBGEMM=OFF
ENV USE_FAKELOWP=OFF
ENV BUILD_TEST=OFF
ENV USE_MKLDNN=OFF
ENV USE_NNPACK=OFF
ENV USE_XNNPACK=OFF
ENV USE_QNNPACK=OFF
ENV USE_PYTORCH_QNNPACK=OFF
ENV USE_CUDA=ON
ENV USE_CUDNN=ON
ENV TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2"
ENV USE_NCCL=OFF
ENV USE_SYSTEM_NCCL=OFF
ENV USE_OPENCV=OFF
ENV MAX_JOBS=$MAX_JOBS
# set path to ccache
ENV PATH=/usr/lib/ccache:$PATH
# set clang compiler
ENV CC=clang
ENV CXX=clang++
# create symlink to cublas
# ln -s /usr/lib/aarch64-linux-gnu/libcublas.so /usr/local/cuda/lib64/libcublas.so
# start the build
RUN python3.8 setup.py bdist_wheel
RUN find /pytorch/dist/ -type f|xargs python3.8 -m pip install

# torch vision
RUN git clone --depth=1 https://github.com/pytorch/vision torchvision -b v0.12.0
RUN cd torchvision && \
  TORCH_CUDA_ARCH_LIST='5.3;6.2;7.2' \
  FORCE_CUDA=1 \
  python3.8 setup.py bdist_wheel
