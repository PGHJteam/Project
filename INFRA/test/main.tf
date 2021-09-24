provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Name = var.name
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"

  aws_region             = var.aws_region
  subnet_id              = module.vpc.public_subnet_id[0]
  vpc_security_group_ids = module.vpc.ec2_sg_id
}