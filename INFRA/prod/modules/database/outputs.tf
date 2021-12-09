output "availability_zone" {
  description = "The availability zone of the db instance."
  value       = aws_db_instance.rds.availability_zone
}

output "endpoint" {
  description = "The connection endpoint in address:port format."
  value       = aws_db_instance.rds.endpoint
}

output "status" {
  description = "The RDS instance status."
  value       = aws_db_instance.rds.status
}
