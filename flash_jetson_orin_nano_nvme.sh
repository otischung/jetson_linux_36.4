#!/bin/bash

set -euo pipefail

mkdir -p logs
PROJ_BASE=$(pwd)

cd Linux_for_Tegra/
sudo ./tools/kernel_flash/l4t_initrd_flash.sh --external-device nvme0n1p1 \
    -c tools/kernel_flash/flash_l4t_t234_nvme.xml -p "-c bootloader/generic/cfg/flash_t234_qspi.xml" \
    --showlogs --network usb0 jetson-orin-nano-devkit internal \
    > ${PROJ_BASE}/logs/flash.log 2> ${PROJ_BASE}/logs/flash_error.log
