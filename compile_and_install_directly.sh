#!/bin/bash

set -euo pipefail

# Environment variables
export INSTALL_MOD_PATH=/
# export IGNORE_PREEMPT_RT_PRESENCE=1
export KERNEL_HEADERS=$(pwd)/Linux_for_Tegra/source/kernel/kernel-jammy-src

# Building the Jetson Linux Kernel
cd Linux_for_Tegra/source
./generic_rt_build.sh "disable"
make -C kernel
sudo -E make install -C kernel
cp kernel/kernel-jammy-src/arch/arm64/boot/Image ../kernel/Image
sudo cp kernel/kernel-jammy-src/arch/arm64/boot/Image /boot/Image
sudo chmod 755 /boot/Image
sudo chown root:root /boot/Image

# Building the NVIDIA Out-of-Tree Modules
make modules
sudo -E make modules_install
sudo nv-update-initrd

# # Building the DTBs
# # You cannot copy the dtbs to /boot directly
# make dtbs
# cp kernel-devicetree/generic-dts/dtbs/* ../kernel/dtb/
cd ../..
