output "lambda_arns" {
  description = "Bản đồ chứa ARN của các hàm Lambda đã khởi tạo, sử dụng key là định danh Lambda"
  value       = { for k, v in aws_lambda_function.this : k => v.arn }
}

output "lambda_function_names" {
  description = "Bản đồ chứa tên của các hàm Lambda đã khởi tạo, sử dụng key là định danh Lambda"
  value       = { for k, v in aws_lambda_function.this : k => v.function_name }
}

output "lambda_roles" {
  description = "Bản đồ chứa thông tin ARN IAM Role của từng Lambda"
  value       = { for k, v in aws_iam_role.lambda_role : k => v.arn }
}
