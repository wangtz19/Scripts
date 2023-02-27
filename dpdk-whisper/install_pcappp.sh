#!/bin/bash

set -exuo pipefail

# Install Dependencies
apt install -y --no-install-recommends \
    libpcap-dev \
    libstdc++6
# end of list

# Download PcapPlusPlus
: "${PCAPPP_VERSION:=21.05}" # some function apis are modified in new versions

mkdir -p "/home/PcapPlusPlus"
wget -q -O "PcapPlusPlus.tar.gz" "https://github.com/seladb/PcapPlusPlus/archive/v$PCAPPP_VERSION.tar.gz"
tar -xzf "PcapPlusPlus.tar.gz" -C "/home/PcapPlusPlus" --strip-components=1
cd "/home/PcapPlusPlus"
./configure-linux.sh --dpdk --dpdk-home "/home/dpdk"
# AVX is needed for DPDK v19
LDFLAGS="-mavx" make libs -j"$(nproc)"
make install