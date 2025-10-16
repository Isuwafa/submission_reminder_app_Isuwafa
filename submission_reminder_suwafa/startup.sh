#!/bin/bash

# Running Submission Reminder App
echo "Starting submission reminder app"

# Get the directory where this script is located
sub_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if app directory exists
if [ ! -d "$sub_dir/app" ]; then
    echo "Error: Application directory not found!"
    exit 1
fi

# Check if reminder.sh script exists
reminder_file="$sub_dir/app/reminder.sh"

if [ ! -f "$reminder_file" ]; then
    echo "Error: reminder.sh script not found!"
    exit 1
fi

# Run the reminder application
echo "Loading reminder application..."

cd "$sub_dir"

# Execute the reminder.sh script
bash $reminder_file
