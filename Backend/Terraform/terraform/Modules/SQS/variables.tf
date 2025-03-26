variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}
variable "upload_bucket_arn" {
  description = "The ARN of the S3 bucket to store the uploaded files."
  type        = string
  
}