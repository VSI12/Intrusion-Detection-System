terraform {
  backend "s3" {
    bucket         = var.bucket
    key            = var.key
    region         = var.region
    dynamodb_table = var.dynamodb_table
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

