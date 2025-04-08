output "nextjs_service_sg" {
  value       = aws_security_group.nextjs_service_sg.id
  description = "The security group ID for the NextJS ECS service"
}