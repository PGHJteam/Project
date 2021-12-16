# 자료메이커 Infra
"자료메이커" 모바일 앱 서비스의 인프라 프로비저닝을 위한 테라폼 코드를 개발합니다.
<br><br>

## 인프라 구성
![인프라 구성](https://user-images.githubusercontent.com/67676029/146353939-50fe57e6-dd29-4e1b-a955-8a70aa479ede.png)

<br>

## 모듈 구성
![모듈](https://user-images.githubusercontent.com/67676029/146353955-8ef14065-ec1e-444f-aee8-0e749930b4ab.png)

#### [Network] 
* VPC, Subnet, IGW, NAT, Route Table

#### [Server] 
* EC2, Load Balancer, S3, Security Group

#### [Database] 
* RDS, Security Group

#### [Security] 
* IAM

#### [Bastion]
* EC2, Security Group
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

#### [Bastion]
* EC2 - aws_key_pair / aws_instance
* Security Group - aws_security_group
