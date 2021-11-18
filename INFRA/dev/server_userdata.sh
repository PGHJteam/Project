#!/bin/bash
apt-get update
apt-get install -y git
apt-get install -y python3.7
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
/usr/bin/python3.7 -m pip install --upgrade pip

apt-get install -y cmake
apt-get install -y nvidia-driver-418
apt-get install -y python3-pip 

apt-get install -y build-essential
sapt-get install -y python3.7-dev
