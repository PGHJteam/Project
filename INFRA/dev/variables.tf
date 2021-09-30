variable "env"{
  description = "Environment for default tags."
  type        = string
  default     = "dev"
}

variable "name"{
  description = "Name for default tags."
  type        = string
  default     = "pghj"
}

variable "terraform"{
  description = "Whether managed by terraform."
  type        = bool
  default     = true
}


####################################
# for ec2
####################################
variable "ec2_key"{
  description = "Name of the key pair for EC2 instance."
  type        = string
  default     = ""
}

variable "ec2_name"{
  description = "Name of the EC2 instance."
  type        = string
  default     = ""
}

variable "ec2_type"{
  description = "Instance type for the EC2 instance."
  type        = string
  default     = ""
}

variable "ec2_filename"{
  description = "File name for the EC2 userdata."
  type        = string
  default     = ""
}

variable "ec2_ami"{
  description = "AMI for the EC2 instance."
  type        = string
  default     = "" 
}

####################################
# for rds
####################################
variable "rds_name"{
  description = "Name of the RDS instance."
  type        = string
  default     = ""
}

variable "rds_type"{
  description = "Instance type for the RDS instance."
  type        = string
  default     = ""
}

variable "rds_engine"{
  description = "DB engine for the RDS instance."
  type        = string
  default     = ""
}

variable "rds_engine_version"{
  description = "Version of DB engine for the RDS instance."
  type        = string
  default     = ""
}

variable "rds_dbname"{
  description = "Database name in the RDS instance."
  type        = string
  default     = ""
}

variable "rds_username"{
  description = "Master user id to access the RDS instance."
  type        = string
  default     = ""
}

variable "rds_password"{
  description = "Master user password to access the RDS instance."
  type        = string
  default     = ""
}

variable "rds_port"{
  description = "Port number to access the RDS instance."
  type        = string
  default     = ""
}

variable "rds_subnet_group_name"{
  description = "Name of the subnet group for the RDS instance."
  type        = string
  default     = "pghj-rds-subnet-group"
}

variable "rds_allocated_storage"{
  description = "Mininum amount of storage for the RDS instance."
  type        = string
  default     = ""
}

variable "rds_max_allocated_storage"{
  description = "Maximum amount of storage for the RDS instance."
  type        = string
  default     = ""
}