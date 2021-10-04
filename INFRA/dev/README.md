# Infrastructure for 'test server'

## Guide
#### 1. EC2 올리기
```
terraform init
terraform apply
```
#### 2. ssh로 ec2 접속

#### 3. ec2에 장고 서버 올리기
```
git clone https://github.com/apphia39/pghj_api_test
cd pghj_api_test/pghj_server
pip3 install -r requirements.txt
python3 manage.py runserver 0:8000
```
