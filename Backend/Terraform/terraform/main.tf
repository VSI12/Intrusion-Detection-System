terraform {
    backend "s3" {
        bucket         = "ids-backend-bucket"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "ids-backend-table-dev"
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}