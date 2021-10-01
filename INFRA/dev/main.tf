locals {
  region             = "ap-northeast-2"
  availability_zones = ["${local.region}a", "${local.region}b"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "pghj"
  }
}

module "vpc" {
  source = "github.com/apphia39/terraform-aws-vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  igw_cidr             = var.igw_cidr

  vpc_name     = "${local.tags.Environment}-${local.tags.Name}-vpc"
  public_name  = "${local.tags.Environment}-${local.tags.Name}-public"
  private_name = "${local.tags.Environment}-${local.tags.Name}-private"
  igw_name     = "${local.tags.Environment}-${local.tags.Name}-igw"

  subnet_num = "2"
  subnet_az  = local.availability_zones

}

module "ec2" {
  source = "github.com/apphia39/terraform-aws-ec2"

  ec2_key  = var.ec2_key
  ec2_type = "t2.micro"
  ec2_ami  = "ami-0ba5cd124d7a79612"

  ec2_name     = "${local.tags.Environment}-${local.tags.Name}-ec2"
  ec2_userdata = file("${var.ec2_filename}")

  ec2_subnet_id          = module.vpc.public_subnet_ids[0]
  ec2_security_group_ids = module.vpc.ec2_sg_ids

  ec2_root_volume = [{
    volume_size = 10
  }]
}

module "rds" {
  source = "github.com/apphia39/terraform-aws-rds"

  rds_name              = "${local.tags.Environment}-${local.tags.Name}-rds"
  rds_subnet_group_name = "${local.tags.Environment}-${local.tags.Name}-rds-subnet-group"

  rds_dbname   = var.rds_dbname
  rds_username = var.rds_username
  rds_password = var.rds_password
  rds_port     = var.rds_port

  rds_subnet_ids         = module.vpc.private_subnet_ids
  rds_security_group_ids = module.vpc.rds_sg_ids

  rds_type                  = "db.t2.micro"
  rds_engine                = "mysql"
  rds_engine_version        = "5.7"
  rds_allocated_storage     = "10"
  rds_max_allocated_storage = "50"

  rds_skip_final_snapshot = true
  rds_publicly_accessible = false
  rds_deletion_protection = false

  rds_allow_major_version_upgrade = false
  rds_apply_immediately           = false
  rds_auto_minor_version_upgrade  = true
}