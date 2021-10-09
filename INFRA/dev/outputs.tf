output "server_public_ip" {
  description = ""
  value       = module.server.public_ip
}

output "server_status" {
  description = ""
  value       = module.server.instance_state
}

output "server_bucket_name" {
  description = ""
  value       = module.server.s3_bucket_name
}

/*
output "db_endpoint" {
  description = ""
  value       = module.database.endpoint
}

output "db_status" {
  description = ""
  value       = module.database.status
}

*/