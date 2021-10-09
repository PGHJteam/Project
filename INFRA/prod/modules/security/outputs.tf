output "bastion_iam_profile" {
  description = ""
  value       = aws_iam_instance_profile.bastion.name
}