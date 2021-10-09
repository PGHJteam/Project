resource "aws_ecs_service" "ecs" {
  name            = "ecs"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.ecs_subnets
    security_groups  = aws_security_group.ecs_sg[*].id
    assign_public_ip = false
  }

  #iam_role = var.ecs_iam_role

  #load_balancer{
  #  target_group_arn = aws_lb_target_group.ecs_lb.arn
  #  container_name = ""
  #  container_port = "8000"
  #}
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "ecs_task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "hello"
      image     = "hello-world"
      cpu       = 256
      memory    = 512
      essential = true
      protMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      #environment:[
      #  {"name": "NAME", "value": "DBNAME"},
      #  {"name": "HOST", "value": ""},
      #  {"name": "USER", "value": ""},
      #  {"name": "PASSWORD", "value": ""}
      #]
    },
  ])
}

