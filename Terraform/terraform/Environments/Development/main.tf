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
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
  public_cidr = var.public_cidr
}

module "ecr" {
  source = "../../modules/ecr"
  flask_ecr = var.flask_ecr
  next_ecr = var.next_ecr
  environment = var.environment
}