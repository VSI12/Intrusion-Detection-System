module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  environment = var.environment
}

module "vpc" {
  source               = "../../modules/vpc"
  environment          = var.environment
  vpc_cidr_block       = var.vpc_cidr_block
  vpc_name             = var.vpc_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  public_cidr          = var.public_cidr
}

module "ecr" {
  source      = "../../modules/ecr"
  flask_ecr   = var.flask_ecr
  next_ecr    = var.next_ecr
  environment = var.environment
}

module "alb" {
  source                  = "../../modules/alb"
  environment             = var.environment
  alb_name_external       = var.alb_name_external
  nextjs_fargate_tg      = var.nextjs_fargate_tg
  nextjs_fargate_listener = var.nextjs_fargate_listener
  external_alb_port       = var.external_alb_port
  external_alb_protocol   = var.external_alb_protocol
  vpc_id                 = module.vpc.vpc_id
  public_subnets          = module.vpc.public_subnet_ids
}