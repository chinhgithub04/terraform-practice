# 1. Tách biệt logic tạo bản ghi DNS tự động vào locals theo quy tắc 4
locals {
  # Chỉ tạo bản ghi DNS xác thực nếu cung cấp zone_id và bật create_route53_records
  create_validation_records = var.zone_id != null && var.create_route53_records

  validation_records = local.create_validation_records ? {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}
}

# 2. Khởi tạo tài nguyên ACM Certificate
resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  # Đảm bảo chứng chỉ mới được cấp trước khi hủy chứng chỉ cũ (Tránh downtime)
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-acm"
  }
}

# 3. Tạo bản ghi DNS xác thực tự động trên Route 53 (nếu được kích hoạt)
resource "aws_route53_record" "validation" {
  for_each = local.validation_records

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

# 4. Xác thực chứng chỉ ACM
resource "aws_acm_certificate_validation" "this" {
  count                   = var.validate_certificate ? 1 : 0
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = local.create_validation_records ? [for r in aws_route53_record.validation : r.fqdn] : null
}
