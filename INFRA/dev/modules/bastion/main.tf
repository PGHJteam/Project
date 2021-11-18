##################################################
# Key Pair
##################################################
resource "aws_key_pair" "bastion" {
  key_name   = var.bastion_key
  public_key = file("${var.bastion_key}")
}

##################################################
# EC2 instance
##################################################
resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  associate_public_ip_address = true
  availability_zone           = var.bastion_az
  iam_instance_profile        = var.bastion_iam_profile
  instance_type               = var.bastion_type
  key_name                    = aws_key_pair.bastion.key_name

  subnet_id              = var.bastion_subnet_id
  user_data              = var.bastion_userdata
  vpc_security_group_ids = aws_security_group.bastion[*].id

  tags = {
    Name = "${var.name_prefix}-bastion"
  }

  lifecycle {
    # prevent_destroy = true
    create_before_destroy = true 
  }
}

##################################################
# Security Group
##################################################
resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id
  name   = "bastion"

  dynamic "ingress" {
    for_each = var.bastion_sg_port

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}