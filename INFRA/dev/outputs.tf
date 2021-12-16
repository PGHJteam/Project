######################################################
# bastion
######################################################
output "bastion_public_ip" {
  description = ""
  value       = module.bastion.public_ip
}

output "bastion_status" {
  description = ""
  value       = module.bastion.instance_state
}

######################################################
# server
######################################################
output "server_status" {
  description = ""
  value       = module.server.instance_state
}

output "server_bucket_name" {
  description = ""
  value       = module.server.s3_bucket_name
}

output "server_dns_name"{
  description = ""
  value       = module.server.lb_dns_name
}

######################################################
# database
######################################################
output "db_endpoint" {
  description = ""
  value       = module.database.endpoint
}

output "db_status" {
  description = ""
  value       = module.database.status
}