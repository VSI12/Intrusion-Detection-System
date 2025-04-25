environment    = "production"
vpc_name       = "IDS-Production-VPC"
vpc_cidr_block = "10.1.0.0/16"

public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]
public_cidr        = "0.0.0.0/0"
flask_ecr_name     = "flask-repo-prod"
next_ecr_name      = "nextjs-repo-prod"

alb_name_external       = "IDS-ALB-External-Prod"
alb_name_internal       = "IDS-ALB-Internal-Prod"
nextjs_fargate_tg       = "ids-nextjs-fargate-tg-Prod"
nextjs_fargate_listener = "ids-nextjs-fargate-listener-Prod"
flask_fargate_tg        = "ids-flask-fargate-tg-Prod"
flask_fargate_listener  = "ids-flask-fargate-listener-Prod"
external_alb_port       = 80
external_alb_protocol   = "HTTP"

#ECS
cluster_name         = "ids-development-cluster-Prod"
nextjs_service       = "ids-development-nextjs-service-Prd"
next_container_port  = 3000
flask_service        = "ids-development-flask-service-Prod"
flask_container_port = 5000
