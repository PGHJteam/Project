output "server_iam_profile" {
  description = "Name of the IAM Profile for the ec2 server."
  value       = aws_iam_instance_profile.server.name
}