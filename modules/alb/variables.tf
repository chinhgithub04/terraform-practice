variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "alb_subnet_ids" {
  description = "Danh sách ID các public subnet để đặt ALB"
  type        = list(string)
}
