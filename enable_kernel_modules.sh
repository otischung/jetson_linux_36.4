#!/bin/bash

set -euo pipefail

echo "This script will enable the WireGuard, iptables, and exFAT modules in the kernel configuration."
read -p "Do you want to continue? [y/N]: " user_input
user_input=${user_input:-N}

if [[ ! "$user_input" =~ ^[Yy]$ ]]; then
    echo "Exiting..."
    exit 0
fi

cp config/defconfig_wireguard Linux_for_Tegra/source/kernel/kernel-jammy-src/arch/arm64/configs/defconfig
echo "Finished"
