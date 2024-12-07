#!/bin/bash

# Print the input arg with prefix
print_message() {
    echo "👉 $1"
}

# Generate SSH Key
read -p "Enter email for SSH key (e.g., email@example.com): " email
if [[ -z "$email" ]]; then
    echo "[ERROR] Email cannot be empty. Exiting."
    exit 1
fi

read -p "Enter a name for your SSH key (default: id_ed25519): " key_name
if [[ -z "$key_name" ]]; then
    key_name="id_ed25519"
fi

print_message "Generating SSH key with email: $email and name: $key_name"
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/$key_name -q -N ""

print_message "Starting the SSH agent..."
eval "$(ssh-agent -s)"

print_message "Adding SSH private key to the SSH agent..."
ssh-add ~/.ssh/$key_name

print_message "Adding GitHub's host key to known hosts..."
ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts

print_message "Add this SSH public key to your GitHub account."
echo "--------------------------------------------------"
cat ~/.ssh/$key_name.pub
echo "--------------------------------------------------"

read -p "Test the connection to GitHub? [Y/n]: " test_choice
if [[ -z "$test_choice" || "$test_choice" =~ ^[Yy]$ ]]; then
    print_message "Testing connection to GitHub..."
    ssh -T git@github.com
    print_message "All set if the connection was successful."
else
    print_message "Skipping the GitHub connection test."
fi
