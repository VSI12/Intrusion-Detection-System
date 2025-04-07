bucket_name    = "intrusion-detection-system-development-bucket"
environment    = "development"
vpc_name       = "ids-development-vpc"
vpc_cidr_block = "10.0.0.0/16"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]
public_cidr        = "0.0.0.0/0"
flask_ecr_name     = "flask-repo"
next_ecr_name      = "nextjs-repo"

alb_name_external       = "IDS-ALB-External"
alb_name_internal       = "IDS-ALB-Internal"
nextjs_fargate_tg       = "ids-nextjs-fargate-tg"
nextjs_fargate_listener = "ids-nextjs-fargate-listener"
flask_fargate_tg        = "ids-flask-fargate-tg"
flask_fargate_listener  = "ids-flask-fargate-listener"
external_alb_port       = 80
external_alb_protocol   = "HTTP"

#ECS
cluster_name         = "ids-development-cluster"
nextjs_service       = "ids-development-nextjs-service"
next_container_port  = 3000
flask_service        = "ids-development-flask-service"
flask_container_port = 5000
