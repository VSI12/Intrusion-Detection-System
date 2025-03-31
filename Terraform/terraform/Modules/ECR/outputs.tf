output "flask_repo_url" {
  value = aws_ecr_repository.flask_repo.repository_url
}

output "nextjs_repo_url" {
  value = aws_ecr_repository.NextJS_ecr.repository_url
}

output "flask_repo_arn" {
  value = aws_ecr_repository.flask_repo.arn 
}

output "nextjs_repo_arn" {
  value = aws_ecr_repository.NextJS_ecr.arn 
  
}