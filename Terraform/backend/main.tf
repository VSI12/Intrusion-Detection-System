terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.backend_bucket
  lifecycle {
    prevent_destroy = true # Prevents the S3 bucket from being destroyed
  }

}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks_dev" {
  name         = var.backend_table_dev
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "dev"
  }

  lifecycle {
    prevent_destroy = true # Prevents the DynamoDB table from being destroyed
  }
}
resource "aws_dynamodb_table" "terraform_locks_staging" {
  name         = var.backend_table_staging
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "staging"
  }

  lifecycle {
    prevent_destroy = true # Prevents the DynamoDB table from being destroyed
  }
}
resource "aws_dynamodb_table" "terraform_locks_prod" {
  name         = var.backend_table_prod
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "prod"
  }

  lifecycle {
    prevent_destroy = true # Prevents the DynamoDB table from being destroyed
  }
}
