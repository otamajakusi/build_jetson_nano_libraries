FROM nvcr.io/nvidia/l4t-base:r32.6.1
ENV DEBIAN_FRONTEND=noninteractive

ARG VER="4.6.0"
ARG PREFIX=/usr/local
ARG MAX_JOBS

#    setup
RUN cd tmp && mkdir build_opencv
WORKDIR /tmp/build_opencv

#    install_dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        cmake \
        git \
        gfortran \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libcanberra-gtk3-module \
        libdc1394-22-dev \
        libeigen3-dev \
        libglew-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer1.0-dev \
        libgtk-3-dev \
        libjpeg-dev \
        libjpeg8-dev \
        libjpeg-turbo8-dev \
        liblapack-dev \
        liblapacke-dev \
        libopenblas-dev \
        libpng-dev \
        libpostproc-dev \
        libswscale-dev \
        libtbb-dev \
        libtbb2 \
        libtesseract-dev \
        libtiff-dev \
        libv4l-dev \
        libxine2-dev \
        libxvidcore-dev \
        libx264-dev \
        pkg-config \
        python3.8-dev \
        python3.8-dev \
        python3-numpy \
        python3-matplotlib \
        python3-pip \
        qv4l2 \
        v4l-utils \
        v4l2ucp \
        zlib1g-dev

#    git_source ${VER}
RUN git clone --depth 1 --branch ${VER} https://github.com/opencv/opencv.git
RUN git clone --depth 1 --branch ${VER} https://github.com/opencv/opencv_contrib.git

RUN python3 -m pip install -U pip
RUN python3 -m pip uninstall -y numpy
RUN python3.8 -m pip install -U pip
RUN python3.8 -m pip install setuptools
RUN python3.8 -m pip install numpy

RUN apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN echo 'deb https://repo.download.nvidia.com/jetson/common r32.6 main\n\
deb https://repo.download.nvidia.com/jetson/t210 r32.6 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

RUN apt-get update && apt-get install -y nvidia-cuda nvidia-cudnn8

RUN cd opencv && \
      mkdir build && \
      cd build && \
      cmake \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=ON \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=${PREFIX} \
        -D CUDA_ARCH_BIN=5.3,6.2,7.2 \
        -D CUDA_ARCH_PTX= \
        -D CUDA_FAST_MATH=ON \
        -D CUDNN_VERSION='8.0' \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3  \
        -D ENABLE_NEON=ON \
        -D OPENCV_DNN_CUDA=ON \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/tmp/build_opencv/opencv_contrib/modules \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_CUBLAS=ON \
        -D WITH_CUDA=ON \
        -D WITH_CUDNN=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF \
        -D PYTHON3_EXECUTABLE=python3.8 \
        -D PYTHON3_INCLUDE_PATH=$(python3.8 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON3_PACKAGES_PATH=$(python3.8 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D PYTHON3_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.8.so \
        -D CPACK_BINARY_DEB=ON \
        -D CPACK_PACKAGING_INSTALL_PREFIX=${PREFIX} \
        ..
WORKDIR /tmp/build_opencv/opencv/build
RUN make -j${MAX_JOBS}
RUN make install
RUN cpack -G DEB
