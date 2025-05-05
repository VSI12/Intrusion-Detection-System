output "flask_repo_url" {
  value       = aws_ecr_repository.flask_repo.repository_url
  description = "The ECR URL for the flask ECR Repo"
}

output "nextjs_repo_url" {
  value       = aws_ecr_repository.NextJS_ecr.repository_url
  description = "The ECR URL for the NextJS ECR Repo"
}

output "flask_repo_arn" {
  value = aws_ecr_repository.flask_repo.arn
}

output "nextjs_repo_arn" {
  value = aws_ecr_repository.NextJS_ecr.arn

}
