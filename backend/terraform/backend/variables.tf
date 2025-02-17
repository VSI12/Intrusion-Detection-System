variable "backend_bucket" {
    description = "S3 bucket where the tfstate files of the "
    type = string
}

variable "backend_table" {
    description = "DynamoDB table to store the locks for the tfstate files"
    type = string
}
