##################################################
# Key Pair
##################################################
resource "aws_key_pair" "server" {
  key_name   = var.ec2_key
  public_key = file("${var.ec2_key}")
}

##################################################
# EC2 instance
##################################################
resource "aws_instance" "server" {
  ami                         = var.ec2_ami
  associate_public_ip_address = var.ec2_associate_public_ip_address
  availability_zone           = var.ec2_az

  disable_api_termination = var.ec2_disable_api_termination
  hibernation             = var.ec2_hibernation

  iam_instance_profile                 = var.ec2_iam_instance_profile
  instance_initiated_shutdown_behavior = var.ec2_instance_initiated_shutdown_behavior
  instance_type                        = var.ec2_type

  key_name   = aws_key_pair.server.key_name
  monitoring = var.ec2_monitoring

  private_ip            = var.ec2_private_ip
  secondary_private_ips = var.ec2_secondary_private_ips
  subnet_id             = var.ec2_subnet_id

  user_data              = var.ec2_userdata
  vpc_security_group_ids = aws_security_group.server[*].id

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
    Name = "${var.name_prefix}-server"
  }

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

##################################################
# Security Group
##################################################
resource "aws_security_group" "server" {
  vpc_id = var.vpc_id
  name   = "${var.name_prefix}-server"

  dynamic "ingress" {
    for_each = var.ec2_sg_port

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb" {
  vpc_id = var.vpc_id
  name   = "${var.name_prefix}-lb"

  dynamic "ingress" {
    for_each = var.lb_sg_port

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################
# S3
##################################################
resource "aws_s3_bucket" "server" {
  bucket = "${var.name_prefix}-server"
  acl    = "private"

  tags = {
    Name = "${var.name_prefix}-server"
  }

  lifecycle {
    prevent_destroy = true 
    create_before_destroy = true
  }
}

##################################################
# Load Balancer
##################################################
resource "aws_lb" "lb" {
  name               = "${var.name_prefix}-lb"
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  ip_address_type    = var.lb_ip_address_type
  idle_timeout       = var.lb_idle_timeout

  security_groups = [aws_security_group.lb.id]
  subnets         = var.public_subnet_ids

  lifecycle {
    prevent_destroy = true
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "lb" {
  name     = "${var.name_prefix}-lb"
  protocol = "HTTP"
  port     = 8000
  vpc_id   = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-lb"
  }
}

resource "aws_lb_target_group_attachment" "lb" {
  target_group_arn = aws_lb_target_group.lb.arn
  target_id        = aws_instance.server.id
  port             = 8000
}

resource "aws_alb_listener" "http80" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
}

resource "aws_alb_listener" "http8000" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
}