#!/bin/bash

set -euo pipefail

# Untar the files and assemble the rootfs
tar xvf Jetson_Linux_R36.4.0_aarch64.tbz2
sudo tar xpvf Tegra_Linux_Sample-Root-Filesystem_R36.4.0_aarch64.tbz2 -C Linux_for_Tegra/rootfs/
cd Linux_for_Tegra/
sudo ./tools/l4t_flash_prerequisites.sh
sudo ./apply_binaries.sh
cd ..

# Expand the Kernel Sources
tar xvf public_sources.tbz2 -C Linux_for_Tegra/..
cd Linux_for_Tegra/source

tar xvf kernel_src.tbz2
tar xvf kernel_oot_modules_src.tbz2
tar xvf nvidia_kernel_display_driver_source.tbz2
cd ../..

# Expand the Jetson Linux Toolchain
mkdir -p l4t-gcc
tar -jxvf aarch64--glibc--stable-2022.08-1.tar.bz2 -C l4t-gcc
