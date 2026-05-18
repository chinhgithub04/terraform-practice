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

# Task Definition variables
variable "task_family" {
  description = "Tên family của ECS task definition"
  type        = string
}

variable "task_network_mode" {
  description = "Network mode cho ECS task (awsvpc, bridge, host)"
  type        = string
  default     = "awsvpc"
}

variable "task_cpu" {
  description = "Đơn vị CPU dùng cho task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Hard limit của memory"
  type        = number
  default     = 1024
}

variable "task_memory_reservation" {
  description = "Soft limit của memory"
  type        = number
  default     = 512
}

variable "container_name" {
  description = "Tên của container trong task"
  type        = string
}

variable "container_image" {
  description = "Đường dẫn image pull từ ECR/Docker Hub để chạy container"
  type        = string
}

variable "container_port" {
  description = "Port mà container lắng nghe"
  type        = number
}

variable "task_execution_role_arn" {
  description = "ARN của role cho phép ECS agent tải image và in logs"
  type        = string
}

variable "task_role_arn" {
  description = "ARN của role cho phép task gọi các AWS services khác (S3, SQS, KMS, v.v...)"
  type        = string
}

# ECS Service variables
variable "ecs_service_name" {
  description = "Tên của ECS service"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "Số lượng tasks mong muốn chạy cho service"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "ARN của target group để ALB forward đến service"
  type        = string
}

variable "ecs_service_subnets" {
  description = "Danh sách ID các private subnet để chạy ECS tasks"
  type        = list(string)
}

variable "ecs_service_security_groups" {
  description = "Danh sách ID các security group áp dụng cho ECS tasks"
  type        = list(string)
}
