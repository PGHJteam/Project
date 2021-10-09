output "address" {
  description = "The hostname of the RDS instance."
  value       = aws_db_instance.rds.address
}

output "arn" {
  description = "The ARN of the RDS instance."
  value       = aws_db_instance.rds.arn
}

output "allocated_storage" {
  description = "The amount of allocated storage."
  value       = aws_db_instance.rds.allocated_storage
}

output "availability_zone" {
  description = "The availability zone of the instance."
  value       = aws_db_instance.rds.availability_zone
}

output "endpoint" {
  description = "The connection endpoint in address:port format."
  value       = aws_db_instance.rds.endpoint
}

output "id" {
  description = "The RDS instance ID."
  value       = aws_db_instance.rds.id
}

output "instance_class" {
  description = "The RDS instance class."
  value       = aws_db_instance.rds.instance_class
}

output "maintenance_window" {
  description = "The instance maintenance window."
  value       = aws_db_instance.rds.maintenance_window
}

output "resource_id" {
  description = "The RDS Resource ID of this instance."
  value       = aws_db_instance.rds.resource_id
}

output "status" {
  description = "The RDS instance status."
  value       = aws_db_instance.rds.status
}
