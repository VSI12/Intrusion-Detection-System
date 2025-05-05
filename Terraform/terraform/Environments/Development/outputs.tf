output "flask_repo_url" {
  value = module.ecr.flask_repo_url
}

output "nextjs_repo_url" {
  value = module.ecr.nextjs_repo_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name

}
