output "public_ip" {
  description = "The public ip of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "instance_state" {
  description = "The state of the bastion host."
  value       = aws_instance.bastion.instance_state
}