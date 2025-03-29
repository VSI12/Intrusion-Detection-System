module "s3" {
  source       = "../../modules/s3"
  bucket_name  = var.bucket_name
  environment  = var.environment
}

module "vpc" {
  source = "../../modules/vpc"
  environment = var.environment
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
}