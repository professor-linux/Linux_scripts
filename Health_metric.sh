#!/bin/bash

# Check if smartctl is installed
if ! command -v smartctl &> /dev/null; then
    echo "smartctl command not found. Please install smartmontools package."
    exit 1
fi

# Find disk names (e.g., sda, sdb, hda, etc.) excluding partitions
disk_names=$(ls /dev/sd? /dev/hd? 2> /dev/null)

# Iterate through disk names
for disk_name in $disk_names; do
    echo "=============================================="

    # Determine disk type (RAID or regular)
    disk_type=$(sudo smartctl -i $disk_name; echo $?)

    echo $disk_type

    if [[ $disk_name =~ ^/dev/sd. ]]; then
        echo "Disk: $disk_name Type: SCSI"
    elif [[ $disk_name =~ ^/dev/hd. ]]; then
        echo "Disk: $disk_name Type: MDE/IDE"
    fi

    
    if [[ $disk_type -eq 2 ]]; then
    
        smart_summary=$(sudo smartctl -x -d megaraid,0 $disk_name  > /dev/null)
        # Process smart_summary as needed
        echo "$smart_summary" | awk '/Serial/ {print $NF}'

    fi
done
