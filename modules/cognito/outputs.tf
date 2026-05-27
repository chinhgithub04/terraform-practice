output "user_pool_id" {
  description = "ID của Cognito User Pool"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN của Cognito User Pool"
  value       = aws_cognito_user_pool.this.arn
}

output "user_pool_endpoint" {
  description = "Endpoint (URL) của Cognito User Pool"
  value       = aws_cognito_user_pool.this.endpoint
}

output "client_ids" {
  description = "Bản đồ chứa Client ID của các Cognito User Pool Clients đã tạo. Key là hậu tố định danh client."
  value       = { for k, v in aws_cognito_user_pool_client.this : k => v.id }
}

output "client_secrets" {
  description = "Bản đồ chứa Client Secret của các Cognito User Pool Clients đã tạo (nếu có generate_secret = true)"
  value       = { for k, v in aws_cognito_user_pool_client.this : k => v.client_secret }
  sensitive   = true
}

output "cognito_domain" {
  description = "Tên miền đã đăng ký cho Cognito Hosted UI (nếu có)"
  value       = length(aws_cognito_user_pool_domain.this) > 0 ? aws_cognito_user_pool_domain.this[0].cloudfront_distribution_arn : null
}
