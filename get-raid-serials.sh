#!/bin/bash

# Find Health Metric for only MegaRaid Disks

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
    disk_type=$(sudo udevadm info $disk_name | grep -i raid | awk -F= '{print $NF}')

    if [[ $disk_name =~ ^/dev/sd. ]]; then
        echo "Disk: $disk_name type: $disk_type"
    elif [[ $disk_name =~ ^/dev/hd. ]]; then
        echo "Disk: $disk_name type: $disk_type"
    fi

    n=0
    last_iteration=0

    if [[ $disk_type == *"raid"* ]]; then
        smart_summary=$(sudo smartctl -x -d megaraid,$n $disk_name)
        exit_code=$?

        while [[ $exit_code -eq 0 ]]; do
            echo -n "Serial: " && awk '/Serial/ {print $NF}' <<< "$smart_summary"
            n=$((n+1))

            smart_summary=$(sudo smartctl -x -d megaraid,$n $disk_name)
            exit_code=$?
        done

        if [[ $exit_code -eq 1 || $exit_code -eq 2 ]]; then
            last_iteration=1
        fi
    fi

    if [[ $last_iteration -eq 1 ]]; then
        break
    fi
done
