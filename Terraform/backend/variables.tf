variable "backend_bucket" {
  description = "S3 bucket where the tfstate files of the "
  type        = string
}

variable "backend_table_dev" {
  description = "DynamoDB table to store the locks for the tfstate files"
  type        = string
}
variable "backend_table_prod" {
  description = "DynamoDB table to store the locks for the tfstate files"
  type        = string
}
variable "backend_table_staging" {
  description = "DynamoDB table to store the locks for the tfstate files"
  type        = string
}
