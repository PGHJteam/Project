###################################
# VPC
###################################
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = {
    Name = "${var.name_prefix}-vpc"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

###################################
# Subnets
###################################
resource "aws_subnet" "public_subnet" {
  count             = var.subnet_num
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "${var.name_prefix}-public"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.subnet_num
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name_prefix}-private"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

###################################
# Internet Gateway
###################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

###################################
# NAT Gateway
###################################
resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[1].id

  tags = {
    Name = "${var.name_prefix}-nat"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

###################################
# Route Tables
###################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.igw_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.nat_cidr
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name_prefix}-private-rt"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

###################################
# Connect route tables with subnets
###################################
resource "aws_route_table_association" "public" {
  count          = var.subnet_num
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_num
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}