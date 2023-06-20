#!/bin/bash


# Author: Zayden Rahman
echo -e "\n"
echo "Printing Users on System "

# Getting users UID based on a typical range which is over 1000

users=$(awk -F: '$3 > 1000 {print $1}' /etc/passwd)

count=$(wc -l <<< $users )

echo "Total Users: $count"
echo -e "\n"
# Loop over all the users
echo " User List"
echo "=========="

for user in $users; do
echo "$user"
done
