#!/bin/bash
pip3 install --upgrade setuptools pip
git clone https://apphia39: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@github.com/apphia39/pghj_api_test
cd pghj_api_test/pghj_server/models
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ" -O craft.pth && rm -rf ~/cookies.txt
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0" -O recog.pth && rm -rf ~/cookies.txt
cd ../
pip3 install -r requirements.txt
python3 manage.py makemigrations files
python3 manage.py makemigrations users
python3 manage.py migrate
python3 manage.py runserver 0:8000