variable "aws_region" {
  description = "Vùng AWS dùng để triển khai tài nguyên (ví dụ: us-east-1)"
  type        = string
}

variable "availability_zones" {
  description = "Danh sách các Availability Zone dùng để triển khai (ví dụ: ['us-east-1a'])"
  type        = list(string)
}

variable "project_name" {
  description = "Tên dự án dùng để gán nhãn và làm tiền tố cho tài nguyên"
  type        = string
}
