output "instance_state" {
  description = "The state of the ec2 server."
  value       = aws_instance.server.instance_state
}

output "s3_bucket_name" {
  description = "Name of the s3 bucket for the media files."
  value       = aws_s3_bucket.server.id
}

output "lb_dns_name"{
  description = "DNS of the load balancer."
  value       = aws_lb.lb.dns_name
}