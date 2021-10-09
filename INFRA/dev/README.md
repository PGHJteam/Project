# Infrastructure for 'test server'

## Guide
#### 1. EC2 올리기
```
terraform init
terraform apply
```
#### 2. ssh로 ec2 접속

#### 3. script.sh 파일 작성하기(복붙)
```
pip3 install --upgrade setuptools pip
git clone https://apphia39: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@github.com/apphia39/pghj_api_test
cd pghj_api_test/pghj_server/models
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ" -O craft.pth && rm -rf ~/cookies.txt
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0" -O recog.pth && rm -rf ~/cookies.txt
cd ../
pip3 install -r requirements.txt
python3 manage.py runserver 0:8000
```

### 4. script 실행하기
```
chmod 755 script.sh
./script.sh
```