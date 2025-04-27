#GENERAL CONFIGURATION

variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "environment" {
  description = "Deployment environment (Development, staging, Production)"
  type        = string
}
variable "availability_zones" {
  description = "List of AWS Availability Zones for subnets "
  type        = list(string)
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "role_name" {
  description = "ECS service execution role name"
  type        = string
  default     = "ecs-service-role"
}


#NETWORKING

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_cidr" {
  description = "public cidr"
  type        = string
}

# Elastic Container Registry (ECR)

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

#External ALB

variable "alb_name_external" {
  description = "Name of the external-facing ALB"
  type        = string
}
variable "external_alb_port" {
  description = "Port to expose on the external ALB (default: 80)"
  type        = number
  default     = 80
}
variable "external_alb_protocol" {
  description = "Protocol used by the external ALB"
  type        = string
  default     = "HTTP"
}

#Next.JS Target groups and Listener.

variable "nextjs_fargate_tg" {
  description = "Target group name for the Next.js Fargate service"
  type        = string
}
variable "nextjs_fargate_listener" {
  description = "Listener name for the Next.js Fargate service"
  type        = string
}

# Internal ALB (for internal backend services)

variable "alb_name_internal" {
  description = "Name of the internal ALB for backend services"
  type        = string
}
variable "internal_alb_port" {
  description = "Port to expose on the internal ALB (default: 80)"
  type        = number
  default     = 80
}
variable "internal_alb_protocol" {
  description = "Protocol used by the internal ALB"
  type        = string
  default     = "HTTP"
}

#Flask Target groups and Listener.

variable "flask_fargate_tg" {
  description = "Target group name for the Flask Fargate service"
  type        = string
}
variable "flask_fargate_listener" {
  description = "Listener name for the Flask Fargate service"
  type        = string
}


#ELASTIC CONTAINER SERVICE

variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

# Next.js Frontend Service

variable "nextjs_service" {
  description = "ECS service name for the Next.js frontend"
  type        = string
}
variable "next_container_port" {
  description = "Container port exposed by the Next.js service"
  type        = string
}


# Flask Backend Service

variable "flask_service" {
  description = "ECS service name for the Flask backend"
  type        = string
}
variable "flask_container_port" {
  description = "Container port exposed by the Flask service"
  type        = string
}

variable "fargate_cpu" {
  description = "CPU units for Fargate tasks"
  type        = string
  default     = "256"
}

variable "fargate_memory" {
  description = "Memory for Fargate tasks"
  type        = string
  default     = "512"
}
