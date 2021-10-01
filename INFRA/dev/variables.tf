# vpc
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
  description = "CIDR block for the INTERNET GATEWAY"
  type        = string
  default     = ""
}


# ec2
variable "ec2_key" {
  description = "Key name of the Key Pair to use for the EC2 instance."
  type        = string
  default     = ""
}

variable "ec2_filename" {
  description = "Name of script file to use for the EC2 instance userdata."
  type        = string
  default     = ""
}


# rds
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