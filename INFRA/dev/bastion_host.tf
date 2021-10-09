##################################################
# Key Pair
##################################################
/*resource "aws_key_pair" "bastion" {
  key_name   = var.ec2_key
  public_key = file("${var.bastion_key}.pub")
}*/

##################################################
# EC2 instance
##################################################
/*resource "aws_instance" "bastion" {
  ami                         = "ami-0ba5cd124d7a79612"
  associate_public_ip_address = true
  availability_zone           = local.availability_zones[0]

  disable_api_termination = var.ec2_disable_api_termination

  iam_instance_profile                 = var.ec2_iam_instance_profile
  instance_type                        = "t2.micro"
  key_name   = aws_key_pair.bastion.key_name

  subnet_id             = module.network.public_subnet_ids[0]
  user_data              = file("bastion.sh")
  vpc_security_group_ids = aws_security_group.ec2_sg[*].id

  tags = {
    Name = var.ec2_name
  }
}*/

##################################################
# Security Group
##################################################
/*resource "aws_security_group" "bastion" {
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
}*/