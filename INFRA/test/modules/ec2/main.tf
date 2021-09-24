resource "aws_key_pair" "apphia" {
  key_name   = "apphia"
  public_key = file("${path.module}/apphia.pub")
}

resource "aws_instance" "ec2" {
  ami           = lookup(var.aws_amis, var.aws_region)
  instance_type = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key

  tags = {
    Name = "ec2"
  }
}