#!/bin/bash

# Print the input arg with a prefix
print_message() {
    echo "👉 $1"
}

# Prompt for venv name, use default if no input is provided
read -p "Enter virtual environment name (default: venv): " VENV_NAME

if [ -z "$VENV_NAME" ]; then
    VENV_NAME="venv"
    print_message "No name provided, using default virtual environment name: $VENV_NAME"
fi

# Create the venv
python3 -m venv "$VENV_NAME"

if [ $? -ne 0 ]; then
    print_message "Failed to create '$VENV_NAME'."
    exit 2
fi

print_message "Virtual environment '$VENV_NAME' created."

# Activate
source "$VENV_NAME/bin/activate"

# Make the file executable: chmod +x create_venv.sh if needed
