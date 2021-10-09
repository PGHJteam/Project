##################################################
# Key Pair
##################################################
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.ec2_key
  public_key = file("${var.ec2_key}.pub")
}

##################################################
# EC2 instance
##################################################
resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami
  associate_public_ip_address = var.ec2_associate_public_ip_address
  availability_zone           = var.ec2_az

  disable_api_termination = var.ec2_disable_api_termination
  hibernation             = var.ec2_hibernation

  iam_instance_profile                 = var.ec2_iam_instance_profile
  instance_initiated_shutdown_behavior = var.ec2_instance_initiated_shutdown_behavior
  instance_type                        = var.ec2_type

  key_name   = aws_key_pair.ec2_key_pair.key_name
  monitoring = var.ec2_monitoring

  private_ip            = var.ec2_private_ip
  secondary_private_ips = var.ec2_secondary_private_ips
  subnet_id             = var.ec2_subnet_id

  user_data              = var.ec2_userdata
  vpc_security_group_ids = aws_security_group.ec2_sg[*].id

  dynamic "root_block_device" {
    for_each = var.ec2_root_volume

    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ec2_ebs_volume

    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}

##################################################
# Security Group
##################################################
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = "bastion_sg"

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
    description = "outbound rule for bastion host security group"
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################
# S3
##################################################
resource "aws_s3_bucket" "server-bucket" {
  bucket = "${var.name_prefix}-server-bucket"
  acl    = "private"

  tags = {
    Name = "${var.name_prefix}-server-bucket"
  }

/*
  lifecycle {
    prevent_destroy = true 
  }
  */
}

##################################################
# Load Balancer
##################################################



