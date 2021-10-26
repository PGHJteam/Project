#!/bin/bash
apt-get update
apt-get install -y git
apt-get install unzip
apt-get install -y mysql-client
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install