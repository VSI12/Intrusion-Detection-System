#External Load balancer
resource "aws_lb" "ids_alb_external" {
  name               = var.alb_name_external
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nextjs_alb_sg.id]
  subnets            = var.public_subnets

  tags = {
    Environment = var.environment
    Name        = var.alb_name_external
  }
}

resource "aws_lb_listener" "nextjs_fargate" {
  load_balancer_arn = aws_lb.ids_alb_external.arn
  port              = var.external_alb_port
  protocol          = var.external_alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nextjs_fargate.arn
  }

  tags = {
    Environment = var.environment
    Name        = var.nextjs_fargate_listener
  }
}

resource "aws_lb_target_group" "nextjs_fargate" {
  name        = var.nextjs_fargate_tg
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  tags = {
    Environment = var.environment
    Name        = var.nextjs_fargate_tg
  }
}

#Internal Load Balancer
resource "aws_lb" "ids_alb_internal" {
  name               = var.alb_name_internal
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nextjs_alb_sg.id]
  subnets            = tolist([var.private_subnets[0], var.private_subnets[1]])

  tags = {
    Environment = var.environment
    Name        = var.alb_name_internal
  }
}

resource "aws_lb_listener" "flask_fargate" {
  load_balancer_arn = aws_lb.ids_alb_internal.arn
  port              = var.internal_alb_port
  protocol          = var.internal_alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_fargate.arn
  }

  tags = {
    Environment = var.environment
    Name        = var.flask_fargate_listener
  }
}

resource "aws_lb_target_group" "flask_fargate" {
  name        = var.flask_fargate_tg
  port        = var.flask_port
  protocol    = var.flask_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  tags = {
    Environment = var.environment
    Name        = var.flask_fargate_tg
  }
}
