output "bucket_id" {
  description = "Tên (ID) của S3 bucket chứa code frontend"
  value       = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  description = "ARN của S3 bucket chứa code frontend"
  value       = aws_s3_bucket.frontend.arn
}
