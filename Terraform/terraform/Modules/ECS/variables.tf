variable "cluster_name" {
  description = "value of the ECS cluster name"
  type        = string
}

variable "environment" {
  description = "value of the environment name"
  type        = string
}

variable "backend_taskdefinition" {
  description = "value of the backend task definition name"
  type        = string
}

variable "container_def" {
  description = "value of the container definition name"
  type        = string
}