resource "aws_ecs_cluster" "IDS_cluster" {
  name = var.cluster_name

  tags = {
    Name        = var.cluster_name
    environment = var.environment
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = aws_ecr_repository.flask_repo.repository_url
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
