resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id
  name   = "ecs_sg"

  dynamic "ingress" {
    for_each = var.ecs_sg_port

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