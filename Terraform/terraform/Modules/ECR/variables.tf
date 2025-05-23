variable "next_ecr_name" {
  description = "The name of the ECR repository"
  type        = string
}
variable "flask_ecr_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}