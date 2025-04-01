resource "aws_security_group" "nextjs_alb_sg" {
  name        = "${var.alb_name_external}-sg"
  description = "Security group for the NextJS ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.alb_name_external}-sg"
    Environment = var.environment
  }
}

