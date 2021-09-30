locals{
  ec2_name = "${var.env}-${var.ec2_name}"
  rds_name = "${var.env}-${var.rds_name}"
}

module "vpc" {
  source = "github.com/apphia39/terraform-aws-vpc"
}

module "ec2" {
  source = "github.com/apphia39/terraform-aws-ec2"

  ec2_key      = var.ec2_key
  ec2_name     = local.ec2_name
  ec2_type     = var.ec2_type  
  ec2_userdata = file("${var.ec2_filename}")

  ec2_ami                = var.ec2_ami
  ec2_subnet_id          = module.vpc.public_subnet_ids[0]
  ec2_security_group_ids = module.vpc.ec2_sg_ids
}

/*
module "rds" {
  source = "github.com/apphia39/terraform-aws-rds"

  rds_name = local.rds_name
  rds_type = var.rds_type

  rds_engine         = var.rds_engine
  rds_engine_version = var.rds_engine_version

  rds_dbname   = var.rds_dbname
  rds_username = var.rds_username
  rds_password = var.rds_password
  rds_port     = var.rds_port

  rds_subnet_group_name  = var.rds_subnet_group_name
  rds_subnet_ids         = module.vpc.private_subnet_ids
  rds_security_group_ids = module.vpc.rds_sg_ids

  rds_allocated_storage     = var.rds_allocated_storage
  rds_max_allocated_storage = var.rds_max_allocated_storage

  rds_skip_final_snapshot = true
  rds_publicly_accessible = false
  rds_deletion_protection = false

  rds_allow_major_version_upgrade = false
  rds_apply_immediately           = false
  rds_auto_minor_version_upgrade  = true
}*/