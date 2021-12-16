######################################################
# network
######################################################
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the PRIVATE SUBNET"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the PUBLIC SUBNET"
  type        = list(string)
  default     = []
}

variable "igw_cidr" {
  description = ""
  type        = string
  default     = ""
}

variable "nat_cidr" {
  description = ""
  type        = string
  default     = ""
}

variable "subnet_num" {
  description = ""
  type        = string
  default     = ""
}

######################################################
# server
######################################################
variable "ec2_key" {
  description = "Key name of the Key Pair to use for the EC2 instance."
  type        = string
  default     = ""
}

variable "ec2_type" {
  description = ""
  type        = string
  default     = ""
}

variable "ec2_ami" {
  description = ""
  type        = string
  default     = ""
}

variable "ec2_filename" {
  description = "Name of script file to use for the EC2 instance userdata."
  type        = string
  default     = ""
}

variable "ec2_root_volume" {
  description = "Root volume for the EC2 instance."
  type        = list(any)
  default     = []
}

variable "ec2_sg_port" {
  description = ""
  type        = list(any)
  default     = []
}

variable "lb_sg_port" {
  description = ""
  type        = list(any)
  default     = []
}

######################################################
# bastion
######################################################
variable "bastion_key" {
  description = "Key name of the Key Pair to use for the EC2 instance."
  type        = string
  default     = ""
}

variable "bastion_type" {
  description = ""
  type        = string
  default     = ""
}

variable "bastion_ami" {
  description = ""
  type        = string
  default     = ""
}

variable "bastion_filename" {
  description = "Name of script file to use for the EC2 instance userdata."
  type        = string
  default     = ""
}

variable "bastion_sg_port" {
  description = ""
  type        = list(any)
  default     = []
}


######################################################
# database
######################################################
variable "rds_dbname" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
  default     = ""
}

variable "rds_username" {
  description = "Username for the master DB user."
  type        = string
  default     = ""
}

variable "rds_password" {
  description = "Password for the master DB user."
  type        = string
  default     = ""
}

variable "rds_port" {
  description = "The port on which the DB accepts connections."
  type        = string
  default     = ""
}

variable "rds_type" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_engine" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_engine_version" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_allocated_storage" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_max_allocated_storage" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_skip_final_snapshot" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_publicly_accessible" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_deletion_protection" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_allow_major_version_upgrade" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_apply_immediately" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_auto_minor_version_upgrade" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_sg_port" {
  description = ""
  type        = list(any)
  default     = []
}