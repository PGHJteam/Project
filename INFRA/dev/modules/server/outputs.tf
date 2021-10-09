output "arn" {
  description = "The ARN of the instance."
  value       = aws_instance.ec2.arn
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = aws_instance.ec2.public_ip
}

output "instance_state" {
  description = ""
  value       = aws_instance.ec2.instance_state
}

output "s3_bucket_name"{
  description = ""
  value       = aws_s3_bucket.server-bucket.id
}