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
  description = "Danh sách ID của các subnet private dùng cho RDS và Lambda"
  value       = module.vpc.rds_subnet_ids
}
