# API test server

## Guide
#### 1. 인프라 프로비저닝
```
terraform init
terraform apply
```
#### 2. ssh로 ec2 접속

#### 3. ec2에 필요한 패키지 설치
```
sudo apt-get update
sudo apt-get install git
sudo apt-get install python3
sudo apt-get install python3-pip
```

#### 4. ec2에 장고 서버 올리기
```
git clone {repository url}
cd pghj_server
pip3 install -r requirements.txt
python3 manage.py runserver 0:8000
```
