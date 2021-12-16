##################################################
# subnet group
##################################################
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.name_prefix}-rds-subnet-group"
  subnet_ids = var.rds_subnet_ids
}

##################################################
# RDS instance
##################################################
resource "aws_db_instance" "rds" {
  allocated_storage           = var.rds_allocated_storage
  allow_major_version_upgrade = var.rds_allow_major_version_upgrade
  apply_immediately           = var.rds_apply_immediately
  auto_minor_version_upgrade  = var.rds_auto_minor_version_upgrade
  availability_zone           = var.rds_az

  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window

  copy_tags_to_snapshot     = var.rds_copy_tags_to_snapshot
  customer_owned_ip_enabled = var.rds_customer_owned_ip_enabled

  db_subnet_group_name     = aws_db_subnet_group.rds_subnet_group.name
  delete_automated_backups = var.rds_delete_automated_backups
  deletion_protection      = var.rds_deletion_protection
  domain                   = var.rds_domain
  domain_iam_role_name     = var.rds_domain_iam_role_name

  enabled_cloudwatch_logs_exports = var.rds_enabled_cloud_watch_logs_exports
  engine                          = var.rds_engine
  engine_version                  = var.rds_engine_version
  final_snapshot_identifier       = var.rds_final_snapshot_name

  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled
  identifier                          = "${var.name_prefix}-rds"
  instance_class                      = var.rds_type
  iops                                = var.rds_iops
  license_model                       = var.rds_license_model

  maintenance_window    = var.rds_maintenance_window
  max_allocated_storage = var.rds_max_allocated_storage
  monitoring_interval   = var.rds_monitoring_interval
  monitoring_role_arn   = var.rds_monitoring_role_arn
  name                  = var.rds_dbname
  option_group_name     = var.rds_option_group_name

  parameter_group_name                  = var.rds_parameter_group_name
  password                              = var.rds_password
  performance_insights_enabled          = var.rds_performance_insights_enabled
  performance_insights_kms_key_id       = var.rds_performance_insights_kms_key_id
  performance_insights_retention_period = var.rds_performance_insights_retention_period
  port                                  = var.rds_port
  publicly_accessible                   = var.rds_publicly_accessible

  replicate_source_db = var.rds_replicate_source_db
  skip_final_snapshot = var.rds_skip_final_snapshot
  snapshot_identifier = var.rds_snapshot_name
  storage_type        = var.rds_storage_type

  username               = var.rds_username
  vpc_security_group_ids = aws_security_group.rds_sg[*].id

  lifecycle {
    create_before_destroy = true
  }
}

##################################################
# Security Group
##################################################
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  name   = "${var.name_prefix}-rds_sg"

  dynamic "ingress" {
    for_each = var.rds_sg_port

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
