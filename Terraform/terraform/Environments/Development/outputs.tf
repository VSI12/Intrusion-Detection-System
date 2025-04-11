output "flask_repo_url" {
  value = module.flask_app.repo_url
}

output "nextjs_repo_url" {
  value = module.nextjs_app.repo_url
}

output "alb_dns_name" {
  value = module.ids_alb_external.dns_name
  
}
