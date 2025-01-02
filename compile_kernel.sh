#!/bin/bash

set -euo pipefail

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -l, --log    Enable logging to files in the logs directory."
    echo "  -h, --help   Show this help message and exit."
    exit 0
}

# Parse arguments
LOGGING=false
for arg in "$@"; do
    case $arg in
        -l|--log)
            LOGGING=true
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $arg" >&2
            usage
            ;;
    esac
done

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
if $LOGGING; then
    mkdir -p logs
    make -C kernel > ${PROJ_BASE}/logs/make_kernel.log 2> ${PROJ_BASE}/logs/make_kernel_error.log
    sudo -E make install -C kernel > ${PROJ_BASE}/logs/make_install_kernel.log 2> ${PROJ_BASE}/logs/make_install_kernel_error.log
else
    make -C kernel
    sudo -E make install -C kernel
fi
cp kernel/kernel-jammy-src/arch/arm64/boot/Image ../kernel/Image

# Building the NVIDIA Out-of-Tree Modules
if $LOGGING; then
    make modules > ${PROJ_BASE}/logs/make_modules.log 2> ${PROJ_BASE}/logs/make_modules_error.log
    sudo -E make modules_install > ${PROJ_BASE}/logs/make_install_modules.log 2> ${PROJ_BASE}/logs/make_install_modules_error.log
else
    make modules
    sudo -E make modules_install
fi
cd ..
sudo ./tools/l4t_update_initrd.sh

# Building the DTBs
cd source
if $LOGGING; then
    make dtbs > ${PROJ_BASE}/logs/make_dtbs.log 2> ${PROJ_BASE}/logs/make_dtbs_error.log
else
    make dtbs
fi
cp kernel-devicetree/generic-dts/dtbs/* ../kernel/dtb/
cd ../..

echo "Finished"
