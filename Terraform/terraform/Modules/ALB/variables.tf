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

variable "external_alb_port" {
  description = "The port for the external ALB"
  type        = number
  default     = 80
}

variable "external_alb_protocol" {
  description = "The protocol for the external ALB"
  type        = string
  default     = "HTTP"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}