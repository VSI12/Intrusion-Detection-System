resource "aws_ecs_cluster" "IDS_cluster" {
  name = var.cluster_name

  tags = {
    Name        = var.cluster_name
    environment = var.environment
  }
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = "${aws_ecr_repository.next_ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "nextjs_service" {
  name                              = var.nextjs_service
  cluster                           = aws_ecs_cluster.IDS_cluster.id
  task_definition                   = aws_ecs_task_definition.frontend.arn
  desired_count                     = 2
  health_check_grace_period_seconds = 60 # Set grace period to 60 seconds
  launch_type                       = "FARGATE"

  network_configuration {
    subnets         = tolist([var.private_subnet_ids[0], var.private_subnet_ids[1]])
    security_groups = [aws_security_group.ecs_sg.id] # Replace with your security group ID                                        # Change based on your setup
  }
  load_balancer {
    target_group_arn = var.alb_tg
    container_name   = var.next_ecr
    container_port   = var.next_container_port
  }

  depends_on = [var.alb_listener]
}
