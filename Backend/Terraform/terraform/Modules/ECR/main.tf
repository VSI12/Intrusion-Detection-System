resource "aws_ecr_repository" "IDS_repo" {
  name                 = "IDS-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

    tags = {
        Name        = var.ecr_name
        Environment = var.environment
    }
}
