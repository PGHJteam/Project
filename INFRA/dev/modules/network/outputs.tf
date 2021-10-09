output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "private subnet id"
  value       = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
  description = "public subnet id"
  value       = aws_subnet.public_subnet[*].id
}