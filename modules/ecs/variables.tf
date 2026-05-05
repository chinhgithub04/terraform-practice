variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Tên của ECS cluster"
  type        = string
}

variable "asg_arn" {
  description = "ARN của Auto Scaling Group để làm capacity provider"
  type        = string
}

variable "managed_termination_protection" {
  description = "Bật bảo vệ khi scale in (ENABLED hoặc DISABLED). Khi ENABLED, ECS sẽ không terminate instance nếu có task đang chạy trên đó."
  type        = string
  default     = "ENABLED"
}

variable "managed_scaling_status" {
  description = "Bật scale in/out tự động (ENABLED hoặc DISABLED). Khi ENABLED, ECS sẽ tự động scale in/out dựa trên target capacity. Nếu DISABLED, phải tự tay bật/tắt máy chủ thủ công."
  type        = string
  default     = "ENABLED"
}

variable "target_capacity" {
  description = "Tỉ lệ phần trăm của số máy chủ đang chạy so với tổng số máy chủ được provisioned. Ví dụ: EC2 có tối đa 10 instance, target capacity là 80% thì ECS sẽ duy trì khoảng 8 instance đang chạy."
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags áp dụng cho tất cả resources"
  type        = map(string)
  default     = {}
}
