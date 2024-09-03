#!/bin/bash

# Update the package repository
sudo yum update -y

# Install the Extra Packages for Enterprise Linux (EPEL) repository
sudo amazon-linux-extras install epel -y

# Install NGINX
sudo yum install nginx -y

# Start the NGINX service
sudo systemctl start nginx

# Enable NGINX to start on boot
sudo systemctl enable nginx

# Confirm that NGINX is running
sudo systemctl status nginx
