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
