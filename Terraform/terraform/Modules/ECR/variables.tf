variable "next_ecr" {
    description = "The name of the ECR repository"
    type        = string
}
variable "flask_ecr" {
    description = "The name of the ECR repository"
    type        = string
}

variable "environment" {
    description = "Deployment environment"
    type        = string
}