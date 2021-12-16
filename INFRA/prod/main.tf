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
  igw_cidr             = var.igw_cidr
  nat_cidr             = var.nat_cidr
  subnet_num           = var.subnet_num
  availability_zones   = local.availability_zones
  name_prefix          = "${local.tags.Environment}-${local.tags.Name}"
}

module "server" {
  source = "./modules/server"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  ec2_subnet_id     = module.network.private_subnet_ids[0]
  # ec2_iam_instance_profile = module.security.server_iam_profile
  ec2_key           = var.ec2_key
  ec2_type          = var.ec2_type
  ec2_ami           = var.ec2_ami
  ec2_sg_port       = var.ec2_sg_port
  ec2_root_volume   = var.ec2_root_volume
  lb_sg_port        = var.lb_sg_port
  ec2_userdata = file("${var.ec2_filename}")
  name_prefix  = "${local.tags.Environment}-${local.tags.Name}"
}

module "security" {
  source = "./modules/security"
}

module "bastion" {
  source = "./modules/bastion"

  vpc_id              = module.network.vpc_id
  bastion_subnet_id   = module.network.public_subnet_ids[0]
  bastion_key         = var.bastion_key
  bastion_type        = var.bastion_type
  bastion_ami         = var.bastion_ami
  bastion_sg_port     = var.bastion_sg_port
  bastion_userdata    = file("${var.bastion_filename}")
  name_prefix         = "${local.tags.Environment}-${local.tags.Name}"
}


module "database" {
  source = "./modules/database"

  vpc_id                          = module.network.vpc_id
  rds_subnet_ids                  = module.network.private_subnet_ids
  rds_dbname                      = var.rds_dbname
  rds_username                    = var.rds_username
  rds_password                    = var.rds_password
  rds_port                        = var.rds_port
  rds_sg_port                     = var.rds_sg_port
  rds_type                        = var.rds_type
  rds_engine                      = var.rds_engine
  rds_engine_version              = var.rds_engine_version
  rds_allocated_storage           = var.rds_allocated_storage
  rds_max_allocated_storage       = var.rds_max_allocated_storage
  rds_skip_final_snapshot         = var.rds_skip_final_snapshot
  rds_publicly_accessible         = var.rds_publicly_accessible
  rds_deletion_protection         = var.rds_deletion_protection
  rds_allow_major_version_upgrade = var.rds_allow_major_version_upgrade
  rds_auto_minor_version_upgrade  = var.rds_auto_minor_version_upgrade
  rds_apply_immediately           = var.rds_apply_immediately
  name_prefix                     = "${local.tags.Environment}-${local.tags.Name}"
}