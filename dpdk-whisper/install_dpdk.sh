#!/bin/bash

set -exuo pipefail

# Utility functions

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1
}

# https://stackoverflow.com/a/4024263/15766817
version_lte() {
    printf '%s\n%s' "$1" "$2" | sort -C -V
}

version_lt() {
    ! version_lte "$2" "$1"
}

# Install Dependencies
# apt update -q
apt install -y --no-install-recommends \
    build-essential \
    gcc-multilib \
    kmod \
    libnuma-dev \
    linux-headers-generic \
    iproute2 \
    meson \
    ninja-build \
    pciutils \
    pkgconf \
    python-is-python3 \
    python3-pip \
    python3-pyelftools \
    wget

# end of list

# Download DPDK
: "${DPDK_VERSION:=19.11}"

mkdir -p "/home/dpdk"
wget -q -O "dpdk.tar.xz" "https://fast.dpdk.org/rel/dpdk-$DPDK_VERSION.tar.xz"
tar -xJf "dpdk.tar.xz" -C "/home/dpdk" --strip-components=1
cd "/home/dpdk"
if version_lt "$DPDK_VERSION" 19.11; then
    echo "Building Older DPDK with MAKE"
    make config T=x86_64-native-linuxapp-gcc
    make -j"$(nproc)"
    make install
else
    echo "Building DPDK with MESON"
    if version_lt "$DPDK_VERSION" 21.08; then
        meson build
    else
        meson -Dplatform=generic build
    fi
    ninja -C build
    ninja -C build install
    ldconfig
fi