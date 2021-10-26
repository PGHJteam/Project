# Infrastructure for 'test server'

## Server Setting Guide
#### 1. Infrastructure Provisioning
```
terraform init
terraform apply
```

#### 2. Access bastion host (ssh)

#### 3. Get the private key for the ec2 server in private subnet.
```
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1JsRXEKiYgnQvLcVNA6VVwWzSTx0yTTfY' -O server_key.pem 
chmod 400 ./server_key.pem
```

#### 4. Access ec2 server
```
ssh -i "server_key.pem" ubuntu@{private IP}
```

### 5. Write/Download server.sh & Execute
```
chmod 755 server.sh
./server.sh
```