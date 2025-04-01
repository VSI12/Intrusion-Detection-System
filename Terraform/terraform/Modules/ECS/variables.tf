variable "cluster_name" {
  description = "value of the ECS cluster name"
  type        = string
}

variable "environment" {
  description = "value of the environment name"
  type        = string
}

variable "backend_taskdefinition" {
  description = "value of the backend task definition name"
  type        = string
}

variable "container_def" {
  description = "value of the container definition name"
  type        = string
}

variable "next_ecr" {
  description = "The name of the ECR repository"
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "alb_tg" {
  description = "The ARN of the ALB target group"
  type        = string
}

variable "ecs_sg" {
  description = "The security group ID for the ECS service"
  type        = string
}

variable "alb_listener" {
  description = "The ALB listener ARN"
  type        = string
}

variable "nextjs_service" {
  description = "The name of the ECS service"
  type        = string
}

variable "next_container_port" {
  description = "The name of the container"
  type        = string
}

variable "ecs_execution_role" {
  description = "The ARN of the ECS execution role"
  type        = string
}