# Infrastructure for 'test server'

## Server Setting Guide
#### 1. Infrastructure Provisioning
```
$ terraform init
$ terraform apply
```

#### 2. Access bastion host (ssh)

#### 3. Get the private key for the ec2 server in private subnet. (in bastoin)

#### 4. Access ec2 server (in bastion)

#### 5. Write/Download server.sh & Execute (in server)

#### 6. Modify Database Characterset (in bastion)
```
$ mysql -h {DB host} -u {DB userID} -p {DB userPW}
mysql> show databases;
mysql> use {DB name};
mysql> alter database {DB name} default character set = utf8;
mysql> alter table {table name} convert to character set utf8;
``` 