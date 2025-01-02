#!/bin/bash

# File containing the package list
FILE="./Linux_for_Tegra/tools/l4t_flash_prerequisites.sh"

# Check if the file exists
if [[ ! -f $FILE ]]; then
  echo "File '$FILE' does not exist."
  exit 1
fi

echo -e "\033[1;33mWarning! This script will remove netcat prerequest.\033[0m"
echo -e "\033[1;33mPlease ensure you have already installed the related netcat packages\033[0m"
echo -e "such like netcat-openbsd or netcat-traditional, etc.\n"
read -p "Do you want to continue? [y/N]: " user_input
user_input=${user_input:-N}

if [[ ! "$user_input" =~ ^[Yy]$ ]]; then
    echo "Exiting..."
    exit 0
fi

# Remove 'netcat' from the file
sed -i 's/\bnetcat\b//g' "$FILE"

# Remove any unnecessary whitespace caused by the removal
sed -i 's/[[:space:]]\+/ /g' "$FILE"
sed -i 's/ ( /(/g' "$FILE"
sed -i 's/ )/)/g' "$FILE"

echo "'netcat' has been removed from $FILE."
