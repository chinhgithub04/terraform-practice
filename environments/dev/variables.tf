# Global
variable "aws_region" {
  description = "Region định danh cho tài nguyên"
  type        = string
}

variable "availability_zones" {
  description = "AZ to deploy resources"
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
  description = "Map of public subnets configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR blocks"
  type        = list(string)
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
  description = "Số lượng instance tối thiểu"
  type        = number
}

variable "max_size" {
  description = "Số lượng instance tối đa"
  type        = number
}

variable "desired_capacity" {
  description = "Số lượng instance mong muốn"
  type        = number
}

variable "tags" {
  description = "Các tags bổ sung cho tài nguyên"
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
  description = "Đơn vị CPU dùng cho task"
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
