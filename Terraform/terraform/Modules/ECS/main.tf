resource "aws_ecs_cluster" "IDS_cluster" {
  name = var.cluster_name

  tags = {
    Name = var.cluster_name
    environment = var.environment
  }
}