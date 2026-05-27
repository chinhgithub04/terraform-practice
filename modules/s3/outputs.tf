locals {
  bucket_ids                   = { for k, b in aws_s3_bucket.this : k => b.id }
  bucket_arns                  = { for k, b in aws_s3_bucket.this : k => b.arn }
  bucket_regional_domain_names = { for k, b in aws_s3_bucket.this : k => b.bucket_regional_domain_name }
}

output "bucket_ids" {
  description = "Tên (ID) của các S3 bucket vừa tạo"
  value       = local.bucket_ids
}

output "bucket_arns" {
  description = "ARN của các S3 bucket vừa tạo"
  value       = local.bucket_arns
}

output "bucket_regional_domain_names" {
  description = "Domain name vùng của các S3 bucket vừa tạo (dùng làm Origin cho CloudFront)"
  value       = local.bucket_regional_domain_names
}
