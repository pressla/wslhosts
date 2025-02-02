#!/bin/bash

# Get WSL instance name and IP
WSL_INSTANCE=$(basename $(cat /etc/hostname))
WSL_IP=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)

# Ensure localhost entry exists for sudo to work
if ! grep -q "127.0.0.1.*$WSL_INSTANCE" /etc/hosts; then
    echo "127.0.0.1 $WSL_INSTANCE" | sudo tee -a /etc/hosts >/dev/null
fi

# Get Windows username
WIN_USER=$(cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')

# Define shared Windows hosts file path
WIN_HOSTS="/mnt/c/Users/${WIN_USER}/.wslhosts"

# Create and install the update script
UPDATE_SCRIPT="/usr/local/bin/update-wslhosts.sh"

cat << EOF | sudo tee $UPDATE_SCRIPT > /dev/null
#!/bin/bash

# Get current WSL instance name
WSL_INSTANCE=$(basename $(cat /etc/hostname))

# Ensure localhost entry exists for sudo to work
if ! grep -q "127.0.0.1.*$WSL_INSTANCE" /etc/hosts; then
    echo "127.0.0.1 $WSL_INSTANCE" | sudo tee -a /etc/hosts >/dev/null
fi

# Get the current WSL IP
WSL_IP=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
if [ -z "$WSL_IP" ]; then
    echo "Error: Could not determine WSL IP address" >&2
    exit 1
fi

# Get Windows username and define shared hosts file
WIN_USER=$(cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')
WIN_HOSTS="/mnt/c/Users/${WIN_USER}/.wslhosts"

# Ensure file exists
touch "$WIN_HOSTS"

# Remove old entry for this WSL instance
grep -v "^[0-9].*[[:space:]]${WSL_INSTANCE}$" "$WIN_HOSTS" > /tmp/wslhosts.tmp
echo "$WSL_IP $WSL_INSTANCE" >> /tmp/wslhosts.tmp
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
