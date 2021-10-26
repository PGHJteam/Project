variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Name prefix for the network resources"
  type        = string
  default     = ""
}

variable "subnet_num" {
  description = "# of subnets"
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

variable "nat_cidr" {
  description = "CIDR block for the NAT GATEWAY"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}