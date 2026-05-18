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

output "ecs_task_definition_arn" {
  description = "ARN của ECS task definition vừa tạo"
  value       = aws_ecs_task_definition.this.arn
}

output "ecs_task_definition_family" {
  description = "Family name của ECS task definition"
  value       = aws_ecs_task_definition.this.family
}

output "ecs_service_name" {
  description = "Tên của ECS service"
  value       = aws_ecs_service.this.name
}

output "ecs_service_id" {
  description = "ID của ECS service"
  value       = aws_ecs_service.this.id
}
