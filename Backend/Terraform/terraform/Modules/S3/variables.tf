variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "queue_arn" {
  description = "The ARN of the SQS queue"
  type        = string
}

variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "queue_policy" {
  description = "The policy of the SQS queue"
  type        = string
}