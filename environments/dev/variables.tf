# Global
variable "aws_region" {
  description = "Region định danh cho tài nguyên"
  type        = string
}

variable "availability_zones" {
  description = "Danh sách các Availability Zone để triển khai tài nguyên"
  type        = list(string)
}

variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
}

# VPC
variable "vpc_cidr" {
  description = "Dải IP của VPC"
  type        = string
}

variable "public_subnets" {
  description = "Bản đồ cấu hình các subnet public (chia rõ loại cho ALB hoặc NAT Gateway)"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    type              = string # "alb" hoặc "nat"
  }))
}

variable "private_subnets" {
  description = "Bản đồ cấu hình các subnet private và chỉ định rõ khóa NAT Gateway để định tuyến ra internet"
  type = map(object({
    cidr_block           = string
    availability_zone    = string
    type                 = string           # "app" hoặc "db"
    nat_gateway_route_to = optional(string) # AZ của public subnet chứa NAT Gateway tương ứng, có thể null.
  }))
}

# Launch Template / EC2
variable "ami_id" {
  description = "ID của AMI để sử dụng trong Launch Template"
  type        = string
}

variable "instance_type" {
  description = "Loại instance để sử dụng trong Launch Template"
  type        = string
}

# Auto Scaling Group
variable "min_size" {
  description = "Số lượng máy chủ EC2 tối thiểu hoạt động trong Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Số lượng máy chủ EC2 tối đa hoạt động trong Auto Scaling Group"
  type        = number
}

variable "desired_capacity" {
  description = "Số lượng máy chủ EC2 mong muốn chạy trong Auto Scaling Group"
  type        = number
}

variable "tags" {
  description = "Bản đồ các thẻ (tags) bổ sung gán cho các tài nguyên hạ tầng"
  type        = map(string)
}

# RDS
variable "db_instance_class" {
  description = "Instance class cho database (vd: db.t3.micro)"
  type        = string
}

variable "db_allocated_storage" {
  description = "Dung lượng storage cấp phát cho RDS (GB)"
  type        = number
}

variable "db_name" {
  description = "Tên database khởi tạo"
  type        = string
}

# ECR
variable "ecr_repository_name" {
  description = "Tên của ECR repository"
  type        = string
}

# ECS
variable "ecs_cluster_name" {
  description = "Tên của ECS cluster"
  type        = string
}

variable "ecs_task_family" {
  description = "Tên family của ECS task definition"
  type        = string
}

variable "ecs_container_name" {
  description = "Tên của container trong task"
  type        = string
}

variable "ecs_service_name" {
  description = "Tên của ECS service"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "Số lượng tasks mong muốn chạy cho service"
  type        = number
}

variable "ecs_task_cpu" {
  description = "Tổng đơn vị CPU cấp phát cho tác vụ ECS Task (vd: 512)"
  type        = number
}

variable "ecs_task_memory" {
  description = "Hard limit của memory"
  type        = number
}

variable "ecs_task_memory_reservation" {
  description = "Soft limit của memory"
  type        = number
}
