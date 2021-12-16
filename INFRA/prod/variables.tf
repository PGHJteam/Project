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
  description = "CIDR block for the INTERNET GATEWAY"
  type        = string
  default     = ""
}

variable "nat_cidr" {
  description = "CIDR block for the NAT GATEWAY"
  type        = string
  default     = ""
}

variable "subnet_num" {
  description = "# of subnets"
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
  description = "The instance type to use for the EC2 server instance."
  type        = string
  default     = ""
}

variable "ec2_ami" {
  description = "AMI ID to use for the EC2 server instance."
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
  description = "A list of the inbound rules of ec2 server security group"
  type        = list(any)
  default     = []
}

variable "lb_sg_port" {
  description = "A list of the inbound rules of load balancer security group"
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
  description = "The instance type to use for the bastion host."
  type        = string
  default     = ""
}

variable "bastion_ami" {
  description = "AMI ID to use for the bastion host."
  type        = string
  default     = ""
}

variable "bastion_filename" {
  description = "Name of script file to use for the EC2 instance userdata."
  type        = string
  default     = ""
}

variable "bastion_sg_port" {
  description = "A list of the inbound rules of bastion host security group"
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
  description = "The instance type of the RDS instance."
  type        = string
  default     = ""
}

variable "rds_engine" {
  description = "The database engine to use."
  type        = string
  default     = ""
}

variable "rds_engine_version" {
  description = "The engine version to use."
  type        = string
  default     = ""
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gibibytes."
  type        = string
  default     = ""
}

variable "rds_max_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance."
  type        = string
  default     = ""
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = string
  default     = ""
}

variable "rds_publicly_accessible" {
  description = "Control if instance is publicly accessible."
  type        = string
  default     = ""
}

variable "rds_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled."
  type        = string
  default     = ""
}

variable "rds_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. "
  type        = string
  default     = ""
}

variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = string
  default     = ""
}

variable "rds_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = string
  default     = ""
}

variable "rds_sg_port" {
  description = "Inbound rules of rds security group"
  type        = list(any)
  default     = []
}