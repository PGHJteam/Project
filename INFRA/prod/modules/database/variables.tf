variable "vpc_id" {
  description = ""
  type        = string
  default     = ""
}

variable "rds_subnet_group_name" {
  description = "Subnet group name for RDS subnet group."
  type        = string
  default     = "rds_subnet_group"
}

variable "rds_subnet_ids" {
  description = "A list of VPC subnet ids for RDS subnet group."
  type        = list(string)
  default     = []
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gibibytes."
  type        = string
  default     = ""
}

variable "rds_max_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance."
  type        = string
  default     = null
}

variable "rds_name" {
  description = "The name of the RDS instance."
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
  default     = null
}

variable "rds_license_model" {
  description = "License model information for this DB instance."
  type        = string
  default     = null
}

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


variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
  default     = null
}

variable "rds_final_snapshot_name" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  type        = string
  default     = null
}

variable "rds_snapshot_name" {
  description = "Specifies whether or not to create this database from a snapshot."
  type        = string
  default     = null
}

variable "rds_copy_tags_to_snapshot" {
  description = "Copy all Instance tags to snapshots."
  type        = bool
  default     = null
}

variable "rds_publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  type        = bool
  default     = null
}

variable "rds_az" {
  description = "The AZ for the RDS instance."
  type        = string
  default     = null
}

variable "rds_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. "
  type        = bool
  default     = null
}

variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = null
}

variable "rds_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = bool
  default     = null
}

variable "rds_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled."
  type        = bool
  default     = null
}

variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance."
  type        = number
  default     = null
}

variable "rds_option_group_name" {
  description = "Name of the DB option group to associate."
  type        = string
  default     = null
}

variable "rds_parameter_group_name" {
  description = "Name of the DB parameter group to associate."
  type        = string
  default     = null
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for."
  type        = number
  default     = null
}

variable "rds_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled."
  type        = string
  default     = null
}

variable "rds_delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  type        = bool
  default     = null
}

variable "rds_ca_cert_name" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
  default     = null
}

variable "rds_domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in."
  type        = string
  default     = null
}

variable "rds_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service."
  type        = string
  default     = null
}

variable "rds_iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = null
}

variable "rds_enabled_cloud_watch_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs."
  type        = list(string)
  default     = null
}

variable "rds_iops" {
  description = "The amount of provisioned IOPS."
  type        = number
  default     = null
}

variable "rds_kms_key_id" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = null
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: ddd:hh24:mi-ddd:hh24:mi."
  type        = string
  default     = null
}

variable "rds_monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = string
  default     = null
}

variable "rds_replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database."
  type        = string
  default     = null
}

variable "rds_storage_type" {
  description = "One of standard, gp2, or io1. The default is io1 if iops is specified, gp2 if not."
  type        = string
  default     = null
}

variable "rds_customer_owned_ip_enabled" {
  description = "Indicates whether to enable a customer-owned IP address (CoIP) for an RDS on Outposts DB instance."
  type        = bool
  default     = null
}

variable "rds_performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled."
  type        = bool
  default     = null
}

variable "rds_performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data. "
  type        = string
  default     = null
}

variable "rds_performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data."
  type        = number
  default     = null
}

############################################
# for s3_import
############################################
variable "s3_engine" {
  description = "(Required) Source engine for the backup."
  type        = string
  default     = null
}

variable "s3_engine_version" {
  description = "(Required) Version of the source engine used to make the backup."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "(Required) The bucket name where your backup is stored."
  type        = string
  default     = null
}

variable "s3_bucket_prefix" {
  description = "(Optional) Can be blank, but is the path to your backup."
  type        = string
  default     = null
}

variable "s3_ingestion_role" {
  description = "(Required) Role applied to load the data."
  type        = string
  default     = null
}


############################################
# for restore_to_point_in_time
############################################
variable "restore_time" {
  description = "The date and time to restore from."
  type        = string
  default     = null
}

variable "source_db_instance_identifier" {
  description = "The identifier of the source DB instance from which to restore."
  type        = string
  default     = null
}

variable "source_dbi_resource_id" {
  description = "The resource ID of the source DB instance from which to restore. Required if source_db_instance_identifier is not specified."
  type        = string
  default     = null
}

variable "use_latest_restorable_time" {
  description = "A boolean value that indicates whether the DB instance is restored from the latest backup time."
  type        = bool
  default     = null
}


variable "rds_sg_port" {
  description = "inbound rules of rds security group"
  default = [
    {
      port = 3306
    }
  ]
}