#!/bin/bash

# Skynet Advanced File Block Analyzer
# Author: @professorlinux
# Version: 1.1

# Define color codes
RED='\033[1;31m'
RESET='\033[0m'

# AI-Like Typing Effect
skynet_echo() {
    local text="$1"
    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.02  # Typing speed
    done
    echo
}

# Trap Signals (Ensures Cleanup on CTRL+C or Failure)
trap 'skynet_echo "[❌] Skynet terminated. Exiting safely."; exit 1' SIGINT SIGTERM

# Ensure Required Commands Exist
for cmd in df ls debugfs tune2fs awk grep wc; do
    if ! command -v "$cmd" &>/dev/null; then
        skynet_echo "[⚠️] Critical Error: Required command '$cmd' not found!"
        exit 1
    fi
done

# Check if filename is provided
if [[ -z "$1" ]]; then
    skynet_echo "[⚠️] Skynet requires a file to analyze."
    skynet_echo "[ℹ️] Usage: $0 <file_path>"
    exit 1
fi

file_path="$1"

# Check if file exists
skynet_echo "[🔍] Verifying file existence..."
sleep 0.5

if [[ ! -e "$file_path" ]]; then
    skynet_echo "[❌] Error: File '$file_path' does not exist."
    exit 1
fi

skynet_echo "[✅] File located: $file_path"
sleep 0.5

# Identify Filesystem Device
skynet_echo "[🔍] Identifying filesystem device..."
sleep 0.5
device=$(df --output=source "$file_path" | tail -1)

if [[ -z "$device" ]]; then
    skynet_echo "[❌] Error: Unable to determine filesystem device."
    exit 1
fi

skynet_echo "[💾] Device identified: $device"

# Retrieve Inode Information
skynet_echo "[🔍] Fetching inode details..."
sleep 0.5
inode=$(ls -i "$file_path" | awk '{print $1}')

if [[ -z "$inode" ]]; then
    skynet_echo "[❌] Error: Unable to retrieve inode number."
    exit 1
fi

skynet_echo "[📌] Inode Number: ${RED}$inode${RESET}"

# Retrieve File Blocks from debugfs
skynet_echo "[🔍] Querying filesystem for block mapping..."
sleep 0.5
blocks=$(sudo debugfs "$device" <<EOF | grep -E 'BLOCKS:' | sed 's/BLOCKS: //'
stat /$file_path
EOF
)

if [[ -z "$blocks" ]]; then
    skynet_echo "[❌] Error: Failed to retrieve block mapping. Ensure the file is on an ext4 filesystem."
    exit 1
fi

skynet_echo "[📊] Blocks allocated to file: ${RED}$blocks${RESET}"

# Retrieve Block Size
skynet_echo "[📏] Fetching filesystem block size..."
sleep 0.5
block_size=$(sudo tune2fs -l "$device" | grep -i "Block size" | awk '{print $NF}')

if [[ -z "$block_size" ]]; then
    skynet_echo "[❌] Error: Unable to determine block size."
    exit 1
fi

skynet_echo "[📐] Block Size: ${RED}$block_size${RESET} bytes"

# Calculate Total Space Occupied
total_blocks=$(echo "$blocks" | wc -w)
total_space=$((block_size * total_blocks))

skynet_echo "[🧮] Computing disk usage..."
sleep 0.5
skynet_echo "[📦] Total Blocks Used: ${RED}$total_blocks${RESET}"
skynet_echo "[💽] Estimated Disk Space Used: ${RED}$total_space${RESET} bytes"

# Final Summary
skynet_echo "[✅] Skynet Analysis Complete. Summary:"
skynet_echo "----------------------------------"
skynet_echo "📂 File Path      : $file_path"
skynet_echo "💾 Device         : $device"
skynet_echo "📌 Inode Number   : ${RED}$inode${RESET}"
skynet_echo "🔢 Blocks Used    : ${RED}$total_blocks${RESET}"
skynet_echo "📐 Block Size     : ${RED}$block_size${RESET} bytes"
skynet_echo "💽 Disk Space Used: ${RED}$total_space${RESET} bytes"
skynet_echo "----------------------------------"
skynet_echo "[🚀] Skynet has finished analyzing the file system. Mission Complete!"
exit 0