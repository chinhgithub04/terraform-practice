variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "ecr_repository_name" {
  description = "Tên của ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Chế độ tag mutability cho image (MUTABLE hoặc IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Bật tính năng scan image khi push lên ECR"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags bổ sung cho ECR repository"
  type        = map(string)
  default     = {}
}
