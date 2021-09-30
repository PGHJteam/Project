#!/bin/bash
apt-get update
apt-get install -y git
apt-get install -y python3
apt-get install -y python3-pip

git clone https://github.com/apphia39/pghj_api_test
cd pghj_api_test/pghj_server
pip3 install -r requirements.txt
python3 manage.py runserver 0:8000