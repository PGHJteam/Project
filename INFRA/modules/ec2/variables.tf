variable "key" {
  description = "Key pair for EC2"
  type        = string
  default     = "apphia"
}

variable "instance_type" {
  description = "Instance Type of EC2"
  type        = string
  default     = "t2.micro"
}

variable "aws_region" {
  description = "Region of EC2"
  type        = string
  default     = ""
}

variable "aws_amis" {
  description = "AMIs of EC2"
  type        = map(any)
  default = {
    "us-east-1"      = "ami-0739f8cdb239fe9ae"
    "us-west-2"      = "ami-008b09448b998a562"
    "us-east-2"      = "ami-0ebc8f6f580a04647"
    "ap-northeast-2" = "ami-0ba5cd124d7a79612"
  }
}

variable "associate_public_ip_address" {
  description = "If true, associate public ip address automatically."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet id for EC2"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "Vpc security group ids for EC2"
  type        = list(string)
  default     = []
}