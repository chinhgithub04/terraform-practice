variable "project_name" {
  description = "Tên dự án dùng để gán Name tag và định danh tài nguyên"
  type        = string
}

variable "domain_name" {
  description = "Tên miền chính để yêu cầu chứng chỉ SSL (ví dụ: example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Danh sách tên miền phụ (SANs) đi kèm chứng chỉ (ví dụ: [\"*.example.com\", \"api.example.com\"])"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Hosted Zone ID của Route 53 để tự động tạo bản ghi DNS xác thực. Nếu để null, bạn cần tự cấu hình bản ghi xác thực thủ công."
  type        = string
  default     = null
}

variable "create_route53_records" {
  description = "Bật/Tắt tự động tạo bản ghi xác thực trên Route 53 (chỉ có hiệu lực khi zone_id khác null)"
  type        = bool
  default     = true
}

variable "validate_certificate" {
  description = "Chờ quá trình xác thực chứng chỉ hoàn tất trước khi kết thúc lệnh terraform apply"
  type        = bool
  default     = true
}
