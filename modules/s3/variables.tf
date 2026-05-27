variable "project_name" {
  description = "Tên dự án dùng để làm tiền tố cho tên bucket"
  type        = string
}

variable "buckets" {
  description = "Bản đồ cấu hình các S3 buckets cần tạo. Key là Tên hậu tố cho bucket (vd: frontend, docs)."
  type        = map(object({}))
}
