#!/bin/bash

# Ask user for their name
echo -n "Please enter your name: "
read -r name

# Check if the name is not empty string
if [ -z "$name" ]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

# Creating main_dir which is submission_reminder_{name}
sub_dir="submission_reminder_${name}"

mkdir -p "$sub_dir"

# Creating directories (app, modules, assets, config)
mkdir -p "$sub_dir/app" "$sub_dir/modules" "$sub_dir/assets" "$sub_dir/config"

# Creating content for config.env
echo "Creating config.env..."

cat > "$sub_dir/config/config.env" << 'JESUS'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
JESUS

# Creating content for functions.sh

echo "Creating functions.sh..."

cat > "$sub_dir/modules/functions.sh" << 'JESUS'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
JESUS

# Creating content of reminder.sh file
echo "Creating reminder.sh..."

cat > "$sub_dir/app/reminder.sh" << 'JESUS'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
JESUS

# Creating content of submissions.txt file
echo "Creating submissions.txt..."

cat > "$sub_dir/assets/submissions.txt" << 'JESUS'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Cynthia, Git, submitted
Suwafa, Shell Permissions, submitted
Milla, Shell Navigation, not submitted
Melo, Shell Basics, submitted
Elie, Git, not submitted
JESUS

echo "submissions.txt file created successfully"

# Create startup.sh file
echo "Creating startup.sh"

cat > "$sub_dir/startup.sh" << 'JESUS'
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
JESUS


# Make script files executable
chmod +x $sub_dir/app/*.sh $sub_dir/modules/*.sh $sub_dir/*.sh