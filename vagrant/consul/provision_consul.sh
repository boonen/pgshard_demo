#!/bin/bash

# Switch to root for setting up systemd
sudo -i

# Copy the apache service into place
mv /tmp/consul/consul.service /etc/systemd/system
mv /tmp/consul/registrator.service /etc/systemd/system
systemctl enable consul.service
systemctl enable registrator.service

# Start for the first time (will start automatically on subsequent reboots)
systemctl restart consul.service
systemctl restart registrator.service