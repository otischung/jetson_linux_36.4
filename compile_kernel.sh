#!/bin/bash

set -euo pipefail

mkdir -p logs
PROJ_BASE=$(pwd)
sudo apt install -y flex bison libssl-dev

# Environment variables
export CROSS_COMPILE=${PROJ_BASE}/l4t-gcc/aarch64--glibc--stable-2022.08-1/bin/aarch64-buildroot-linux-gnu-
export INSTALL_MOD_PATH=${PROJ_BASE}/Linux_for_Tegra/rootfs/
# export IGNORE_PREEMPT_RT_PRESENCE=1
export KERNEL_HEADERS=${PROJ_BASE}/Linux_for_Tegra/source/kernel/kernel-jammy-src

# Building the Jetson Linux Kernel
cd Linux_for_Tegra/source
./generic_rt_build.sh "disable"
make -C kernel > ${PROJ_BASE}/logs/make_kernel.log 2> ${PROJ_BASE}/logs/make_kernel_error.log
sudo -E make install -C kernel > ${PROJ_BASE}/logs/make_install_kernel.log 2> ${PROJ_BASE}/logs/make_install_kernel_error.log
cp kernel/kernel-jammy-src/arch/arm64/boot/Image ../kernel/Image

# Building the NVIDIA Out-of-Tree Modules
make modules > ${PROJ_BASE}/logs/make_modules.log 2> ${PROJ_BASE}/logs/make_modules_error.log
sudo -E make modules_install > ${PROJ_BASE}/logs/make_install_modules.log 2> ${PROJ_BASE}/logs/make_install_modules_error.log
cd ..
sudo ./tools/l4t_update_initrd.sh

# Building the DTBs
cd source
make dtbs > ${PROJ_BASE}/logs/make_dtbs.log 2> ${PROJ_BASE}/logs/make_dtbs_error.log
cp kernel-devicetree/generic-dts/dtbs/* ../kernel/dtb/
cd ../..
