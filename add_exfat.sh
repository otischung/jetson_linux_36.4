#!/bin/bash

set -euo pipefail

TARGET_STRING="CONFIG_EXFAT_FS=y"
FILE="Linux_for_Tegra/source/kernel/kernel-jammy-src/arch/arm64/configs/defconfig"

# Check if the first line contains the target string
if ! head -n 1 "$FILE" | grep -q "$TARGET_STRING"; then
    # Add the target string at the beginning of the file
    sed -i "1s/^/$TARGET_STRING\n\n/" "$FILE"
    echo "Success"
else
    echo "The target string is already present in the first line."
fi
