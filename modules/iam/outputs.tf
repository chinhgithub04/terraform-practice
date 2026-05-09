output "app_server_iam_instance_profile_name" {
  description = "Tên của IAM instance profile cho app server"
  value       = aws_iam_instance_profile.app_server_profile.name
}

output "app_server_iam_role_name" {
  description = "Tên của IAM role cho app server"
  value       = aws_iam_role.app_server_role.name
}

output "ecs_task_execution_role_arn" {
  description = "ARN của ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN của ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}
