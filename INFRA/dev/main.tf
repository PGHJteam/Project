locals {
  region             = "ap-northeast-2"
  availability_zones = ["${local.region}a", "${local.region}b"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "pghj"
  }
}

module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  igw_cidr             = "0.0.0.0/0" # 변수로 빼기
  nat_cidr             = "0.0.0.0/0"
  name_prefix          = "${local.tags.Environment}-${local.tags.Name}"
  subnet_num           = "2"
  availability_zones   = local.availability_zones
}

module "server" { # 변수 통일
  source = "./modules/server"

  vpc_id                   = module.network.vpc_id
  ec2_key                  = var.ec2_key
  ec2_type                 = "t3.xlarge" 
  ec2_ami                  = "ami-0ba5cd124d7a79612" # ubuntu 18.04
  name_prefix              = "${local.tags.Environment}-${local.tags.Name}"
  ec2_userdata             = file("${var.ec2_filename}")
  ec2_subnet_id            = module.network.public_subnet_ids[0] # private 으로 숨기기
  ec2_iam_instance_profile = module.security.server_iam_profile
  # 종료방지기능

  ec2_sg_port = [
    {
      port = "22"
    },
    {
      port = "8000"
    }
  ]
}

module "security" {
  source = "./modules/security"
}

/*
module "database" { # standby 추가??
  source = "./modules/database"
  vpc_id = module.network.vpc_id

  name_prefix  = "${local.tags.Environment}-${local.tags.Name}"

  rds_dbname   = var.rds_dbname
  rds_username = var.rds_username
  rds_password = var.rds_password
  rds_port     = var.rds_port

  rds_subnet_ids = module.network.private_subnet_ids

  rds_type                  = "db.t2.micro" # prod에서는 수정
  rds_engine                = "mysql"
  rds_engine_version        = "5.7"
  rds_allocated_storage     = "10" # 수정
  rds_max_allocated_storage = "50" # 수정

  rds_skip_final_snapshot = true # false
  rds_publicly_accessible = false 
  rds_deletion_protection = false # true

  rds_allow_major_version_upgrade = false
  rds_apply_immediately           = false
  rds_auto_minor_version_upgrade  = true
}*/