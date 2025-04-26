environment    = "Staging"
vpc_name       = "IDS-Staging-VPC"
vpc_cidr_block = "10.2.0.0/16"

public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]
public_cidr        = "0.0.0.0/0"
flask_ecr_name     = "flask-repo-Staging"
next_ecr_name      = "nextjs-repo-Staging"

alb_name_external       = "IDS-ALB-External-Staging"
alb_name_internal       = "IDS-ALB-Internal-Staging"
nextjs_fargate_tg       = "ids-nextjs-fargate-tg-Staging"
nextjs_fargate_listener = "ids-nextjs-fargate-listener-Staging"
flask_fargate_tg        = "ids-flask-fargate-tg-Staging"
flask_fargate_listener  = "ids-flask-fargate-listener-Staging"
external_alb_port       = 80
external_alb_protocol   = "HTTP"

#ECS
cluster_name         = "ids-development-cluster-Staging"
nextjs_service       = "ids-development-nextjs-service-Staging"
next_container_port  = 3000
flask_service        = "ids-development-flask-service-Staging"
flask_container_port = 5000
