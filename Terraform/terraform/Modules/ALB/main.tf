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
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  tags = {
    Environment = var.environment
    Name        = var.nextjs_fargate_tg
  }
}