variable "vpc_id" {
  description = "Vpc id for the server module resources."
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Name prefix for naming the server module resources."
  type        = string
  default     = ""
}

###################################################
# ec2_instance
###################################################
variable "ec2_key" {
  description = "Key name of the Key Pair to use for the EC2 server instance."
  type        = string
  default     = ""
}

variable "ec2_ami" {
  description = "AMI ID to use for the EC2 server instance."
  type        = string
  default     = ""
}

variable "ec2_type" {
  description = "The instance type to use for the EC2 server instance."
  type        = string
  default     = ""
}

variable "ec2_subnet_id" {
  description = "VPC (Private) Subnet ID to launch in."
  type        = string
  default     = null
}

variable "ec2_monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = false
}

variable "ec2_associate_public_ip_address" {
  description = "Whether to associate a public IP address with EC2 instance in a VPC."
  type        = bool
  default     = false
}

variable "ec2_az" {
  description = "Availability zone to start the EC2 instance in."
  type        = string
  default     = null
}

variable "ec2_hibernation" {
  description = "If true, the launched EC2 instance will support hibernation."
  type        = bool
  default     = null
}

variable "ec2_private_ip" {
  description = "Private IP address to associate with the instance in a VPC."
  type        = string
  default     = null
}

variable "ec2_secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC."
  type        = list(any)
  default     = null
}

variable "ec2_placement_group" {
  description = "Placement Group to start the instance in."
  type        = string
  default     = null
}

variable "ec2_disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection."
  type        = bool
  default     = null
}

variable "ec2_instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance."
  type        = string
  default     = null
}

variable "ec2_userdata" {
  description = "User data to provide when launching the instance."
  type        = string
  default     = null
}

variable "ec2_get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = false
}

variable "ec2_iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with."
  type        = string
  default     = null
}

variable "ec2_root_volume" {
  description = "Root volume for the EC2 instance."
  type        = list(any)
  default     = []
}

variable "ec2_ebs_volume" {
  description = "Additional EBS volume for the EC2 instance."
  type        = list(any)
  default     = []
}

###################################################
# security groups
###################################################
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

###################################################
# Load Balancer
###################################################
variable "public_subnet_ids" {
  description = "list of public subnet ids"
  type        = list(string)
  default     = []
}

variable "lb_internal"{
  description = ""
  type        = bool
  default     = false
}

variable "lb_type"{
  description = ""
  type        = string
  default     = "application"
}

variable "lb_ip_address_type"{
  description = ""
  type        = string
  default     = "ipv4"
}

variable "lb_idle_timeout"{
  description = ""
  type        = number
  default     = 900
}
