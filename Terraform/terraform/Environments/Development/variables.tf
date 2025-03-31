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