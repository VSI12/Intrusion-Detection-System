variable "cluster_name" {
  description = "value of the ECS cluster name"
  type        = string
}

variable "environment" {
  description = "value of the environment name"
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

variable "ecs_sg" {
  description = "The security group ID for the ECS service"
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


variable "nextjs_alb_listener_arn" {
  description = "The ARN of the external ALB listener"
  type        = string
}

variable "nextjs_alb_target_group_arn" {
  description = "The ARN of the NextJS Fargate target group"
  type        = string
}
variable "role_name" {
  description = "ECS service role name"
  type        = string

}

variable "nextjs_alb_sg" {
  description = "The security group ID for the NextJS ALB"
  type        = string
}
variable "flask_alb_sg" {
  description = "The security group ID for the Flask ALB"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "next_ecr_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "flask_ecr" {
  description = "The name of the Flask backend ECR repository"
  type        = string
}

variable "flask_ecr_name" {
  description = "The URL of the Flask backend ECR repository"
  type        = string
}

variable "flask_service" {
  description = "The name of the Flask ECS service"
  type        = string
}

variable "flask_container_port" {
  description = "The port for the Flask container"
  type        = string
}

variable "flask_alb_target_group_arn" {
  description = "The ARN of the Flask Fargate target group"
  type        = string
}

variable "nextjs_repo_url" {
  description = "The URL of the NextJS ECR repository"
  type        = string
  
}

variable "flask_repo_url" {
  description = "The URL of the Flask ECR repository"
  type        = string
}