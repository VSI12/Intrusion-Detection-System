variable "alb_name_external" {
  description = "The name of the ALB"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "nextjs_fargate_tg" {
  description = "The name of the NextJS Fargate target group"
  type        = string
}

variable "nextjs_fargate_listener" {
  description = "The name of the NextJS Fargate listener"
  type        = string
}

