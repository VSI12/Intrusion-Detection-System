resource "aws_ecs_cluster" "IDS_cluster" {
  name = var.cluster_name

  tags = {
    Name        = var.cluster_name
    environment = var.environment
  }
}

#ECS SERVICE FOR NEXTJS
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.next_ecr_name}"
      image     = "${var.nextjs_repo_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "INTERNAL_FLASK_API"
          value = "${var.internal_alb_dns_name}"
        }
      ]
    }
  ])

  tags = {
    environment = var.environment
  }
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
    security_groups = [aws_security_group.nextjs_service_sg.id] # Replace with your security group ID                                        # Change based on your setup
  }
  load_balancer {
    target_group_arn = var.nextjs_alb_target_group_arn
    container_name   = var.next_ecr_name
    container_port   = var.next_container_port
  }

  tags = {
    name        = var.nextjs_service
    environment = var.environment
  }
}

# Define IAM Role for ECS Service
resource "aws_iam_role" "ecs_service_role" {
  name = "${var.role_name}-${var.environment}-ecs-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = var.role_name
    environment = var.environment
  }
}

# Attach IAM Role Policy to ECS Service Role
resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "${var.role_name}-${var.environment}-ecs-service-policy"

  role = aws_iam_role.ecs_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "${var.next_ecr}" # Correctly reference the full ECR URI
      },
      {
        Effect   = "Allow"
        Action   = "ecs:UpdateService"
        Resource = "*"
      }
    ]
  })
}

# Define the execution role for ECS Task Definition
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.role_name}-${var.environment}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#ECS SERVICE FOR FLASK
resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.flask_ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.flask_ecr_name}"
      image     = "${var.flask_repo_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "flask_service" {
  name                              = var.flask_service
  cluster                           = aws_ecs_cluster.IDS_cluster.id
  task_definition                   = aws_ecs_task_definition.backend.arn
  desired_count                     = 2
  health_check_grace_period_seconds = 60 # Set grace period to 60 seconds
  launch_type                       = "FARGATE"

  network_configuration {
    subnets         = tolist([var.private_subnet_ids[2], var.private_subnet_ids[3]])
    security_groups = [aws_security_group.flask_service_sg.id] # Replace with your security group ID                                        # Change based on your setup
  }
  load_balancer {
    target_group_arn = var.flask_alb_target_group_arn
    container_name   = var.flask_ecr_name
    container_port   = var.flask_container_port
  }

}

# Define IAM Role for ECS Service
resource "aws_iam_role" "flask_ecs_service_role" {
  name = "${var.role_name}-${var.environment}-flask-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach IAM Role Policy to ECS Service Role
resource "aws_iam_role_policy" "flask_ecs_service_policy" {
  name = "${var.role_name}-${var.environment}-flask-service-policy"
  role = aws_iam_role.flask_ecs_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "${var.flask_ecr}" # Correctly reference the full ECR URI
      },
      {
        Effect   = "Allow"
        Action   = "ecs:UpdateService"
        Resource = "*"
      }
    ]
  })
}

# Define the execution role for ECS Task Definition
resource "aws_iam_role" "flask_ecs_task_execution_role" {
  name = "${var.role_name}-${var.environment}-flask-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "flask_ecs_task_execution_policy" {
  role       = aws_iam_role.flask_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
