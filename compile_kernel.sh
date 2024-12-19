#!/bin/bash

set -euo pipefail

# Environment variables
export CROSS_COMPILE=$(pwd)/l4t-gcc/aarch64--glibc--stable-2022.08-1/bin/aarch64-buildroot-linux-gnu-
export INSTALL_MOD_PATH=$(pwd)/Linux_for_Tegra/rootfs/
# export IGNORE_PREEMPT_RT_PRESENCE=1
export KERNEL_HEADERS=$(pwd)/Linux_for_Tegra/source/kernel/kernel-jammy-src

# Building the Jetson Linux Kernel
cd Linux_for_Tegra/source
./generic_rt_build.sh "disable"
make -C kernel
sudo -E make install -C kernel
cp kernel/kernel-jammy-src/arch/arm64/boot/Image ../kernel/Image

# Building the NVIDIA Out-of-Tree Modules
make modules
sudo -E make modules_install
cd ..
sudo ./tools/l4t_update_initrd.sh

# Building the DTBs
cd source
make dtbs
cp kernel-devicetree/generic-dts/dtbs/* ../kernel/dtb/
cd ../..
