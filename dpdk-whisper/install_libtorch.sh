#!/bin/bash
set -exuo pipefail

apt install -y zip
wget -q -O "libtorch.zip" "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.13.1%2Bcpu.zip"
unzip "libtorch.zip" -d "/home" # will store in /home/libtorch

# Copy libtorch to /usr/local
# INSTALL_DIR=/usr/local
# cd "/home/libtorch"
# mkdir -p $INSTALL_DIR/lib
# cp lib/* $INSTALL_DIR/lib
# mkdir -p $INSTALL_DIR/include
# cp include/* $INSTALL_DIR/include/ -r

# Install mlpack
apt install libmlpack-dev mlpack-bin libarmadillo-dev 

echo Installation complete!