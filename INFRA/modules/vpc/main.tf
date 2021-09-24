###################################
# Create the VPC
###################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

###################################
# Create the Subnets
###################################
resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone[count.index]
  cidr_block        = var.cidr_public_subnet[count.index]

  tags = {
    Name = "public_subnet"
  }
}

###################################
# Create the GATEWAY
###################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

###################################
# Create the Route Tables
###################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_igw
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

###################################
# Connect route tables with subnets
###################################
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

###################################
# Security Groups & Rules
###################################
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "ec2_sg"

  dynamic "ingress" {
    for_each = var.ec2_sg_port

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "outbound rule for public security group"
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}