output "certificate_arn" {
  description = "ARN của chứng chỉ ACM đã được tạo (và xác thực nếu validate_certificate = true)"
  value       = var.validate_certificate ? aws_acm_certificate_validation.this[0].certificate_arn : aws_acm_certificate.this.arn
}

output "certificate_domain_name" {
  description = "Tên miền chính của chứng chỉ ACM"
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "Danh sách chi tiết các bản ghi xác thực DNS (hữu ích cho việc cấu hình thủ công trên các hệ thống DNS bên ngoài)"
  value       = aws_acm_certificate.this.domain_validation_options
}
