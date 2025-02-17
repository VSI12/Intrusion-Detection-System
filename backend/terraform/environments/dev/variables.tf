variable "bucket" {
  description = "The name of the S3 bucket to store the Terraform state file"
  type = string
}

variable "key" {
  description = "The name of the Terraform state file in the S3 bucket"
  type = string
}

variable "region" {
  description = "The AWS region where the S3 bucket is located"
  type = string
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table to use for Terraform state locking"
  type = string
}