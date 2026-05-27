output "cloudfront_domain_name" {
  description = "Tên miền mặc định của CloudFront (ví dụ: d111111abcdef8.cloudfront.net)"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted Zone ID của CloudFront dùng để cấu hình bản ghi Route 53 Alias"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "cloudfront_arn" {
  description = "ARN của CloudFront Distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_status" {
  description = "Trạng thái hiện tại của CloudFront Distribution"
  value       = aws_cloudfront_distribution.this.status
}
