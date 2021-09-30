terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Terraform   = var.terraform == true ? "True" : "False"
      Environment = var.env
      Name        = var.name
    }
  }
}