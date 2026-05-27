output "api_endpoint" {
  description = "URL Endpoint cơ sở của API Gateway để gọi dịch vụ (ví dụ: https://a1b2c3d4.execute-api.ap-southeast-1.amazonaws.com)"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_execution_arn" {
  description = "Execution ARN của API Gateway"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "api_id" {
  description = "ID của API Gateway"
  value       = aws_apigatewayv2_api.this.id
}
