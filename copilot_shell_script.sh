#!/bin/bash

# Get the directory where this config.env is located
sub_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the path to config.env
config_file="$(find "$sub_dir" -type f -path "*/config/config.env" | head -n 1)"

# Define the path to startup.sh
startup_file="$(find "$sub_dir" -type f -name "startup.sh" | head -n 1)"

# Asking user for new assignment name
read -p "Enter the new assignment name: " new_assignment

# Validate input
if [ -z "$new_assignment" ]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

echo
echo "Updating assignment in configuration file..."

# Use sed to replace the ASSIGNMENT value in config.env
sed -i "s|^ASSIGNMENT=.*|ASSIGNMENT=\"$new_assignment\"|" "$config_file"

echo "rerun startup.sh"

# Check if startup.sh exists
if [ ! -f "$startup_file" ]; then
    echo "Error: startup.sh not found!"
    exit 1
fi

# Run the startup script
bash $startup_file