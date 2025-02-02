#!/bin/bash

# Step 1: Set Git Username and Email
git config --global user.name "pressla"
git config --global user.email "pressl.alex@imitrix.de"

# Step 2: Generate SSH Key for GitHub
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "pressl.alex@imitrix.de" -f ~/.ssh/id_ed25519 -N ""

# Step 3: Display the SSH Public Key
echo "Your SSH public key (copy this to GitHub):"
cat ~/.ssh/id_ed25519.pub

# Step 4: Add the SSH Key to GitHub (automated using GitHub API)

# Ensure you have a GitHub personal access token for authentication
# Create a GitHub token with "admin:public_key" scope at https://github.com/settings/tokens
echo "Please provide your GitHub personal access token:"
read -p "GitHub Token: " github_token

# GitHub API URL to add SSH key
github_api_url="https://api.github.com/user/keys"

# Upload SSH key to GitHub
curl -X POST -H "Authorization: token $github_token" \
    -d "{\"title\":\"Debian System SSH Key\",\"key\":\"$(cat ~/.ssh/id_ed25519.pub)\"}" \
    $github_api_url

# Step 5: Verify SSH Connection to GitHub
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com

echo "GitHub registration complete!"
