resource "aws_security_group" "nextjs_service_sg" {
  name        = "ecs-sg"
  description = "Allow traffic from ALB to ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.nextjs_alb_sg] # Allow only ALB SG to access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name        = "ecs-sg"
    Environment = var.environment
  }
}


# SECURITY GROUP FOR THE FLASK SERVICE
# This security group allows traffic from the NextJS ECS service to the Flask ECS service
resource "aws_security_group" "flask_service_sg" {
  name        = "flask-ecs-sg"
  description = "Allow traffic from Nextjs ECS to flask tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [var.flask_alb_sg] # Allow only ALB SG to access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name        = "flask-ecs-sg"
    Environment = var.environment
  }
}