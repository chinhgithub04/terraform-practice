output "app_server_iam_instance_profile_name" {
  description = "Tên của IAM instance profile cho app server"
  value       = aws_iam_instance_profile.app_server_profile.name
}

output "app_server_iam_role_name" {
  description = "Tên của IAM role cho app server"
  value       = aws_iam_role.app_server_role.name
}
