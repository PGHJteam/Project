# 필기해줘 Backend
"필기해줘" 모바일 앱 서비스의 인프라 프로비저닝을 위한 테라폼 코드를 개발합니다.
<br><br>

## 인프라 구성
![image](https://user-images.githubusercontent.com/67676029/136682312-22874173-febc-4257-ba81-b6d6bd506d04.png)

<br>

## 모듈 구성
#### [Network] 
* VPC, Subnet, IGW, NAT, Route Table

#### [Server] 
* EC2, Load Balancer, S3, Security Group

#### [Database] 
* RDS, Security Group

#### [Security] 
* IAM

![image](https://user-images.githubusercontent.com/67676029/136682314-d54fe25d-9cd9-4efb-b59f-65268bbd3ee4.png)

<br>

## 리소스 구성
#### [Network] 
* VPC – aws_vpc
* Subnet – aws_subnet
* IGW – aws_internet_gateway
* NAT – aws_eip / aws_nat_gateway
* Route Table – aws_route_table / aws_route_table_association

#### [Server]
* EC2 – aws_key_pair / aws_instance
* Load Balancer – aws_lb / aws_lb_target_group / aws_lb_listener / aws_lb_target_group_attachment
* S3 - aws_s3_bucket
* Security Group – aws_security_group

#### [Database] 
* RDS – aws_db_subnet_group / aws_db_instance
* Security Group – aws_security_group

#### [Security] 
* IAM – aws_iam_policy / aws_iam_role / aws_iam_role_policy_attachment / aws_iam_instance_profile

#### [Root Module]
* Each child modules
* Bastion host – aws_key_pair / aws_instance / aws_security_group

