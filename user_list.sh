#!/bin/bash


display_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help     Display this help and exit"
    echo "  -u, --users    Display user information"
}

display_users() {
    users=$(who | sort | uniq )
    echo "Name: $users"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
     -h|--help)
        display_help
        exit 0
        ;;
     -u|--users)
       display_users
       exit 0
       ;;
esac
shift
done


users=$(who | sort | uniq | wc -l )
echo "There are currently $users logged in"
