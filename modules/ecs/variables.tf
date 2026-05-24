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

# Task Definition variables
variable "task_family" {
  description = "Tên family của ECS task definition"
  type        = string
}

variable "task_cpu" {
  description = "Đơn vị CPU dùng cho task"
  type        = number
}

variable "task_memory" {
  description = "Hard limit của memory"
  type        = number
}

variable "task_memory_reservation" {
  description = "Soft limit của memory"
  type        = number
}

variable "container_name" {
  description = "Tên của container trong task"
  type        = string
}

variable "container_image" {
  description = "Đường dẫn image pull từ ECR/Docker Hub để chạy container"
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
