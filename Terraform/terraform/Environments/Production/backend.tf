terraform {
  backend "s3" {
    bucket         = "ids-backend-bucket"
    key            = "terraform/state/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "ids-backend-table-prod"
  }
}
