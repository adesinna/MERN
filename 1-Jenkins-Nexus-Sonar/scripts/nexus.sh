#!/bin/bash

# Install Amazon Corretto 17
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo

sudo yum install -y java-17-amazon-corretto-devel wget

# Set up Nexus directories
NEXUS_BASE_DIR="/opt/nexus"
TMP_DIR="/tmp/nexus"
if [ ! -d "$NEXUS_BASE_DIR" ]; then
    sudo mkdir -p $NEXUS_BASE_DIR
fi
mkdir -p $TMP_DIR
cd $TMP_DIR

# Download and extract Nexus
NEXUS_URL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
wget $NEXUS_URL -O nexus.tar.gz

if [ $? -ne 0 ]; then
    echo "Failed to download Nexus. Exiting."
    exit 1
fi

EXTRACT_OUTPUT=$(tar xzvf nexus.tar.gz)
NEXUS_DIR=$(echo $EXTRACT_OUTPUT | head -n 1 | cut -d '/' -f1)

if [ -z "$NEXUS_DIR" ]; then
    echo "Failed to extract Nexus. Exiting."
    exit 1
fi

# Move and set permissions
sudo rm -rf nexus.tar.gz
sudo cp -r $TMP_DIR/* $NEXUS_BASE_DIR/
sudo useradd nexus
sudo chown -R nexus:nexus $NEXUS_BASE_DIR

# Create systemd service
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOT
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=$NEXUS_BASE_DIR/$NEXUS_DIR/bin/nexus start
ExecStop=$NEXUS_BASE_DIR/$NEXUS_DIR/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT

# Configure Nexus to run as nexus user
echo 'run_as_user="nexus"' | sudo tee $NEXUS_BASE_DIR/$NEXUS_DIR/bin/nexus.rc

# Reload systemd, start and enable Nexus service
sudo systemctl daemon-reload
sudo systemctl start nexus

if [ $? -ne 0 ]; then
    echo "Failed to start Nexus service. Check logs for details."
    exit 1
fi

sudo systemctl enable nexus
