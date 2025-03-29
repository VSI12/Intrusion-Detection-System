variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}
