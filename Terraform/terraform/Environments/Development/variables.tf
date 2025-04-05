variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}
variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "ecr_name" {
  description = "ECR Repository Name"
  type        = string
  default     = "ids-repo"
}
variable "public_cidr" {
  description = "public cidr"
  type        = string
}
variable "next_ecr_name" {
  description = "The name of the NextJS frontend ECR repository"
  type        = string
  default     = "nextjs-repo"
}
variable "flask_ecr_name" {
  description = "The name of the Flask backend ECR repository"
  type        = string
}

#APPLICATION LOAD BALANCER
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
variable "alb_name_external" {
  description = "The name of the ALB"
  type        = string
}
#Internal ALB
variable "alb_name_internal" {
  description = "The name of the internal ALB"
  type        = string
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
#ELASTIC CONTAINER SERVICE
variable "cluster_name" {
  description = "value of the ECS cluster name"
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

variable "role_name" {
  description = "ECS service role name"
  type        = string
  default     = "ecs-service-role"
}
