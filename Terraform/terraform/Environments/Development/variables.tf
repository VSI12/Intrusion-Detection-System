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
