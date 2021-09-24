output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "public subnet id"
  value       = aws_subnet.public_subnet[*].id
}

output "ec2_sg_id" {
  description = "ec2 security group id"
  value       = aws_security_group.ec2_sg[*].id
}
