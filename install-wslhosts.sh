#!/bin/bash

# Get WSL instance name
WSL_INSTANCE=$(basename $(cat /etc/hostname))

# Define shared Windows hosts file path
WIN_HOSTS="/mnt/c/Users/$(whoami)/.wslhosts"

# Create and install the update script
UPDATE_SCRIPT="/usr/local/bin/update-wslhosts.sh"

cat << 'EOF' | sudo tee $UPDATE_SCRIPT > /dev/null
#!/bin/bash

# Get current WSL instance name
WSL_INSTANCE=$(basename $(cat /etc/hostname))

# Get the current WSL IP
WSL_IP=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)

# Define the shared Windows hosts file
WIN_HOSTS="/mnt/c/Users/$(whoami)/.wslhosts"

# Ensure file exists
touch "$WIN_HOSTS"

# Remove old entry for this WSL instance
grep -v "$WSL_INSTANCE" "$WIN_HOSTS" > /tmp/wslhosts.tmp
echo "$WSL_INSTANCE $WSL_IP" >> /tmp/wslhosts.tmp
mv /tmp/wslhosts.tmp "$WIN_HOSTS"

# Wait a moment to allow other WSL instances to update
sleep 2

# Update /etc/hosts with all known WSL instances
grep -v "# WSL INSTANCES" /etc/hosts > /tmp/etchosts.tmp
echo "# WSL INSTANCES" >> /tmp/etchosts.tmp
cat "$WIN_HOSTS" >> /tmp/etchosts.tmp
sudo mv /tmp/etchosts.tmp /etc/hosts

echo "Updated $WIN_HOSTS and /etc/hosts with $WSL_INSTANCE -> $WSL_IP"
EOF

# Make the script executable
sudo chmod +x $UPDATE_SCRIPT

# Ensure the script runs at WSL startup
echo -e "[boot]\ncommand=\"$UPDATE_SCRIPT\"" | sudo tee /etc/wsl.conf > /dev/null

# Run the script now to populate the hosts file immediately
sudo $UPDATE_SCRIPT

echo "✅ WSL networking setup complete! Restart WSL to apply changes."
