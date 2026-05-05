output "ecs_cluster_id" {
  description = "ID của ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "Tên của ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
  description = "ARN của ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "ecs_capacity_provider_name" {
  description = "Tên của ECS capacity provider"
  value       = aws_ecs_capacity_provider.this.name
}
