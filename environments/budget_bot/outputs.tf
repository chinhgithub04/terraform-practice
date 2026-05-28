# Outputs S3
output "s3_bucket_ids" {
  description = "Tên (ID) của các S3 bucket vừa tạo"
  value       = module.s3.bucket_ids
}

output "s3_bucket_arns" {
  description = "ARN của các S3 bucket vừa tạo"
  value       = module.s3.bucket_arns
}

output "s3_bucket_regional_domain_names" {
  description = "Domain name vùng của các S3 bucket"
  value       = module.s3.bucket_regional_domain_names
}

# Outputs VPC
output "vpc_id" {
  description = "ID của VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Danh sách ID của các public subnets"
  value       = module.vpc.alb_subnet_ids
}

output "private_subnet_ids" {
  description = "Danh sách ID của tất cả các private subnets"
  value       = module.vpc.private_subnet_ids
}

output "rds_subnet_ids" {
  description = "Danh sách ID của các subnet private dùng cho RDS"
  value       = module.vpc.rds_subnet_ids
}

# Outputs Lambda
output "lambda_function_names" {
  description = "Tên của các hàm Lambda đã khởi tạo"
  value       = module.lambda.lambda_function_names
}

output "lambda_arns" {
  description = "ARN của các hàm Lambda đã khởi tạo"
  value       = module.lambda.lambda_arns
}

# Outputs API Gateway
output "api_endpoint" {
  description = "URL Endpoint cơ sở của API Gateway để gọi dịch vụ (ví dụ: https://a1b2c3d4.execute-api.ap-southeast-1.amazonaws.com)"
  value       = module.api_gateway.api_endpoint
}
