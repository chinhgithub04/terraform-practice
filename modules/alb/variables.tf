variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "target_group_port" {
  description = "Port mà target group sẽ lắng nghe"
  type        = number
}

variable "target_group_protocol" {
  description = "Giao thức sử dụng cho target group (HTTP hoặc HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "health_check_enabled" {
  description = "Có bật health check cho target group không"
  type        = bool
  default     = true
}

variable "health_check_healthy_threshold" {
  description = "Số lần health check thành công để target được coi là healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Số lần health check thất bại để target được coi là unhealthy"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Timeout cho health check (giây)"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Khoảng thời gian giữa các lần health check (giây)"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Đường dẫn để health check"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP status codes sẽ được coi là healthy"
  type        = string
  default     = "200"
}

variable "tags" {
  description = "Tags áp dụng cho tất cả resources"
  type        = map(string)
  default     = {}
}

variable "alb_cidr_blocks" {
  description = "Danh sách các CIDR blocks cho phép truy cập ALB"
  type        = list(string)
}

variable "alb_port" {
  description = "Port mà ALB sẽ lắng nghe"
  type        = number
}

variable "alb_protocol" {
  description = "Giao thức sử dụng cho ALB listener (HTTP hoặc HTTPS)"
  type        = string
}
variable "public_subnet_ids" {
  description = "Danh sách ID các public subnet để đặt ALB"
  type        = list(string)
}
