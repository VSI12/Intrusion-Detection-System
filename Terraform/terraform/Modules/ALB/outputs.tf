output "nextjs_alb_sg_id" {
  description = "The security group ID for the NextJS ALB"
  value       = aws_security_group.nextjs_alb_sg.id
}

output "nextjs_alb_arn" {
  description = "The ARN of the NextJS ALB"
  value       = aws_lb.ids_alb_external.arn
}

output "nextjs_alb_target_group_arn" {
  description = "The ARN of the NextJS Fargate target group"
  value       = aws_lb_target_group.nextjs_fargate.arn
}

output "nextjs_alb_listener_arn" {
  description = "The ARN of the NextJS Fargate listener"
  value       = aws_lb_listener.nextjs_fargate.arn
}
output "flask_alb_sg_id" {
  description = "The security group ID for the Flask ALB"
  value       = aws_security_group.flask_alb_sg.id
}

output "flask_alb_arn" {
  description = "The ARN of the flask ALB"
  value       = aws_lb.ids_alb_internal.arn
}

output "flask_alb_target_group_arn" {
  description = "The ARN of the flask Fargate target group"
  value       = aws_lb_target_group.flask_fargate.arn
}

output "flask_alb_listener_arn" {
  description = "The ARN of the flask Fargate listener"
  value       = aws_lb_listener.flask_fargate.arn
}