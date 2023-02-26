#!/bin/bash

set -e # exit on error
set -x # print commands

apt update

# Required build dependencies
apt install cmake
apt install gcc g++
apt install python3-dev python3-numpy
apt install libavcodec-dev libavformat-dev libswscale-dev
apt install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
apt install libgtk-3-dev

# Optional Dependencies
apt install libpng-dev
apt install libjpeg-dev
apt install libopenexr-dev
apt install libtiff-dev
apt install libwebp-dev

# Download and unpack sources
apt install -y wget unzip
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip
unzip opencv.zip
unzip opencv_contrib.zip

# Create build directory and switch into it
mkdir -p build && cd build

# Enable CUDA
cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.x/modules \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DWITH_OPENEXR=OFF \
        -DWITH_CUDA=ON \
        -DWITH_CUBLAS=ON \
        -DWITH_CUDNN=ON \
        -DOPENCV_DNN_CUDA=ON \
        ../opencv-4.x

# Build
cmake --build .