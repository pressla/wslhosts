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

# Step 6: Append SSH Agent start portion to .bashrc or .zshrc
echo "Appending SSH agent start code to ~/.bashrc..."

# Check if we're using bash or zsh and append the necessary code
if [ -f ~/.bashrc ]; then
    echo -e "\n# inserted by register-github.sh\n" >> ~/.bashrc
    echo "if [ -z \"\$SSH_AUTH_SOCK\" ]; then" >> ~/.bashrc
    echo "  eval \$(ssh-agent -s)" >> ~/.bashrc
    echo "  ssh-add ~/.ssh/id_ed25519" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo "SSH agent start code added to ~/.bashrc"
elif [ -f ~/.zshrc ]; then
    echo -e "\n# inserted by register-github.sh\n" >> ~/.zshrc
    echo "if [ -z \"\$SSH_AUTH_SOCK\" ]; then" >> ~/.zshrc
    echo "  eval \$(ssh-agent -s)" >> ~/.zshrc
    echo "  ssh-add ~/.ssh/id_ed25519" >> ~/.zshrc
    echo "fi" >> ~/.zshrc
    echo "SSH agent start code added to ~/.zshrc"
else
    echo "No recognized shell configuration file found (~/.bashrc or ~/.zshrc)"
fi
