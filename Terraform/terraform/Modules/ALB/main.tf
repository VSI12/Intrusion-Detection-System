#External Load balancer
resource "aws_lb" "ids_alb_external" {
  name               = var.alb_name_external
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Environment = var.environment
    Name        = var.alb_name_external
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ids_alb_external.arn
  port              = "443"
  protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.ids_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}