#!/bin/bash

# Install jumper to enable recovery mode
echo "Install jumper to enable recovery mode."

# Prompt user for storage type
while true; do
    echo "Select storage type:"
    echo "1) SD card"
    echo "2) NVMe"
    read -p "Enter choice (1 or 2): " storage_choice
    case $storage_choice in
        1)
            STORAGE_DEVICE="mmcblk0p1"
            break
            ;;
        2)
            STORAGE_DEVICE="nvme0n1p1"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 or 2."
            ;;
    esac
done

# Confirm if ready to proceed
read -p "Ready to proceed? (yes/no): " proceed
if [[ ! "$proceed" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Exiting script."
    exit 0
fi

# Navigate to Linux_for_Tegra directory
FLASH_DIR="$HOME/jetson_linux_36.4/Linux_for_Tegra"
cd "$FLASH_DIR" || { echo "Error: Cannot change directory to $FLASH_DIR"; exit 1; }

# Instructions for recovery mode and flashing
echo "\nPlace the Jetson target into recovery mode."
echo "Use this command to retrieve the EEPROM and chip information from the board, and to subsequently generate a flash image:"
echo "$ sudo ./flash.sh --no-flash jetson-orin-nano-devkit $STORAGE_DEVICE"

# Run the flash script to retrieve data only
sudo ./flash.sh --no-flash jetson-orin-nano-devkit "$STORAGE_DEVICE"

# Set the path to the bootloader directory
BOOTLOADER_DIR="$HOME/jetson_linux_36.4/Linux_for_Tegra/bootloader"

# Change to the bootloader directory
cd "$BOOTLOADER_DIR" || { echo "Error: Cannot change directory to $BOOTLOADER_DIR"; exit 1; }

# Retrieve configuration variables
BOARDID=$(./chkbdinfo -i cvm.bin)
BOARDSKU=$(./chkbdinfo -k cvm.bin)
FAB=$(./chkbdinfo -f cvm.bin)
BOARDREV=$(./chkbdinfo -r cvm.bin)
CHIP_SKU=$(./chkbdinfo -C chip_info.bin_bak)
RAMCODE_ID=$(./chkbdinfo -R chip_info.bin_bak)
RAMCODE=$(echo "ibase=2; ${RAMCODE_ID//:/}" | bc)

# Display the retrieved values
echo "Jetson Orin Nano Configuration:"
echo "BOARDID: $BOARDID"
echo "BOARDSKU: $BOARDSKU"
echo "FAB: $FAB"
echo "BOARDREV: $BOARDREV"
echo "CHIP_SKU: $CHIP_SKU"
echo "RAMCODE_ID: $RAMCODE_ID"
echo "RAMCODE: $RAMCODE"

# Environment variables to check
env_vars=(
    "CROSS_COMPILE=$(pwd)/l4t-gcc/aarch64--glibc--stable-2022.08-1/bin/aarch64-buildroot-linux-gnu-"
    "INSTALL_MOD_PATH=$(pwd)/Linux_for_Tegra/rootfs/"
    "KERNEL_HEADERS=$(pwd)/Linux_for_Tegra/source/kernel/kernel-jammy-src"
)

# Check if the variables are set
missing_vars=()
echo "\nChecking environment variables:"
for var in "${env_vars[@]}"; do
    key="${var%%=*}"
    value="${!key}"
    if [ -z "$value" ]; then
        missing_vars+=("$var")
        echo "$key is not set."
    else
        echo "$key is set to: $value"
    fi
    echo ""  # Add a blank line after each variable check

done

# Provide instructions for missing variables
if [ ${#missing_vars[@]} -gt 0 ]; then
    echo "\nTo set the missing variables, use the following commands:"
    for var in "${missing_vars[@]}"; do
        echo "export $var"
    done
else
    echo "\nAll required environment variables are set."
fi

