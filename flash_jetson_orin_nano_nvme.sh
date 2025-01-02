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

cd Linux_for_Tegra/
if $LOGGING; then
    mkdir -p logs
    sudo ./tools/kernel_flash/l4t_initrd_flash.sh --external-device nvme0n1p1 \
        -c tools/kernel_flash/flash_l4t_t234_nvme.xml -p "-c bootloader/generic/cfg/flash_t234_qspi.xml" \
        --showlogs --network usb0 jetson-orin-nano-devkit internal \
        > ${PROJ_BASE}/logs/flash.log 2> ${PROJ_BASE}/logs/flash_error.log
else
    sudo ./tools/kernel_flash/l4t_initrd_flash.sh --external-device nvme0n1p1 \
        -c tools/kernel_flash/flash_l4t_t234_nvme.xml -p "-c bootloader/generic/cfg/flash_t234_qspi.xml" \
        --showlogs --network usb0 jetson-orin-nano-devkit internal
fi

echo "Finished"
