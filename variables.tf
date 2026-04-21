variable "aws_region" {
  description = "Region định danh cho tài nguyên"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Dải IP của VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
  default     = "xbrain-project"
}
