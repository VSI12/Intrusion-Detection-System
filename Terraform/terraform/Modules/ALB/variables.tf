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


#Internal Load Balancer
variable "alb_name_internal" {
  description = "The name of the internal ALB"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "internal_alb_port" {
  description = "The port for the internal ALB"
  type        = number
  default     = 5000
}

variable "internal_alb_protocol" {
  description = "The protocol for the internal ALB"
  type        = string
  default     = "HTTP"
}
variable "flask_fargate_listener" {
  description = "The name of the Flask Fargate target group"
  type        = string
}

variable "flask_fargate_tg" {
  description = "The name of the Flask Fargate target group"
  type        = string
}
variable "flask_port" {
  description = "The port for the Flask Fargate target group"
  type        = number
  default     = 5000
}

variable "flask_protocol" {
  description = "The protocol for the internal ALB"
  type        = string
  default     = "HTTP"
}

variable "nextjs_service_sg" {
  description = "The security group ID for the NextJS SG"
  type        = string
  
}