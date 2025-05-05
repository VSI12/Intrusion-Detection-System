module "vpc" {
  source               = "../../Modules/VPC"
  environment          = var.environment
  vpc_cidr_block       = var.vpc_cidr_block
  vpc_name             = var.vpc_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  public_cidr          = var.public_cidr
}

module "ecr" {
  source         = "../../Modules/ECR"
  flask_ecr_name = var.flask_ecr_name
  next_ecr_name  = var.next_ecr_name
  environment    = var.environment
}

module "alb" {
  source                  = "../../Modules/ALB"
  environment             = var.environment
  alb_name_external       = var.alb_name_external
  alb_name_internal       = var.alb_name_internal
  nextjs_fargate_tg       = var.nextjs_fargate_tg
  nextjs_fargate_listener = var.nextjs_fargate_listener
  flask_fargate_listener  = var.flask_fargate_listener
  flask_fargate_tg        = var.flask_fargate_tg
  external_alb_port       = var.external_alb_port
  external_alb_protocol   = var.external_alb_protocol
  internal_alb_port       = var.internal_alb_port
  internal_alb_protocol   = var.internal_alb_protocol

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids

  nextjs_service_sg = module.ecs.nextjs_service_sg
}

module "ecs" {
  source             = "../../Modules/ECS"
  environment        = var.environment
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  nextjs_alb_listener_arn = module.alb.nextjs_alb_listener_arn
  nextjs_alb_sg           = module.alb.nextjs_alb_sg_id

  flask_alb_sg = module.alb.flask_alb_sg_id

  next_ecr_name  = var.next_ecr_name
  flask_ecr_name = var.flask_ecr_name
  next_ecr       = module.ecr.nextjs_repo_arn
  flask_ecr      = module.ecr.flask_repo_arn

  flask_repo_url  = module.ecr.flask_repo_url
  nextjs_repo_url = module.ecr.nextjs_repo_url


  nextjs_service       = var.nextjs_service
  next_container_port  = var.next_container_port
  flask_service        = var.flask_service
  flask_container_port = var.flask_container_port

  fargate_cpu    = var.fargate_cpu
  fargate_memory = var.fargate_memory

  ecs_sg                      = module.alb.nextjs_alb_sg_id
  nextjs_alb_target_group_arn = module.alb.nextjs_alb_target_group_arn
  flask_alb_target_group_arn  = module.alb.flask_alb_target_group_arn
  role_name                   = var.role_name
  internal_alb_dns_name       = module.alb.internal_alb_dns_name
}
