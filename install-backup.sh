#!/bin/bash

# Install required dependencies
sudo apt-get update
sudo apt-get install -y mysql-client tar awscli mailutils

# Copy backup script
sudo cp backup_script.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/backup_script.sh

# Configure AWS CLI
sudo aws configure

# Schedule daily cron job
(crontab -l ; echo "0 0 * * * /usr/local/bin/backup_script.sh") | crontab -

# Log installation process
echo "Backup script installed successfully!"

