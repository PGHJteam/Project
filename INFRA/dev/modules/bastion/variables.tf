variable "vpc_id" {
  description = "Vpc id for the bastion module resources."
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Name prefix for naming the bastion module resources."
  type        = string
  default     = ""
}

variable "bastion_key" {
  description = "Key name of the Key Pair to use for the bastion host."
  type        = string
  default     = ""
}

variable "bastion_ami" {
  description = "AMI ID to use for the bastion host."
  type        = string
  default     = ""
}

variable "bastion_sg_port" {
  description = "A list of the inbound rules of bastion host security group"
  type        = list(any)
  default     = []
}

variable "bastion_az" {
  description = "Availability zone to start the bastion host in."
  type        = string
  default     = ""
}

variable "bastion_iam_profile" {
  description = "Iam Profile for the bastion host."
  type        = string
  default     = ""
}

variable "bastion_type" {
  description = "The instance type to use for the bastion host."
  type        = string
  default     = ""
}

variable "bastion_subnet_id" {
  description = "VPC (Public) Subnet ID to launch in."
  type        = string
  default     = ""
}

variable "bastion_userdata" {
  description = "User data to provide when launching the bastion host."
  type        = string
  default     = ""
}

variable "bastion_associate_public_ip_address"{
  description = "Whether to associate a public IP address with bastion host in a VPC."
  type        = bool
  default     = true
}