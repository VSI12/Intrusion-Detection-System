resource "aws_ecs_cluster" "name" {
  name = var.cluster_name

  tags = {
    Name = var.cluster_name
    environment = var.environment
  }
}