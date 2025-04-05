resource "aws_ecr_repository" "NextJS_ecr" {
  name                 = var.next_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = var.next_ecr_name
    Environment = var.environment
  }
}
resource "aws_ecr_repository" "flask_repo" {
  name                 = var.flask_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = var.flask_ecr_name
    Environment = var.environment
  }
}
