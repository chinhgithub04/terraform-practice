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

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

# Launch Template
variable "ami_id" {
  description = "ID của AMI để sử dụng trong Launch Template"
  type        = string
}

variable "instance_type" {
  description = "Loại instance để sử dụng trong Launch Template"
  type        = string
}

# EBS
variable "ebs_device_name" {
  description = "Tên thiết bị EBS gắn vào instance (vd: /dev/xvda)"
  type        = string
}

variable "ebs_volume_size" {
  description = "Dung lượng EBS (GiB)"
  type        = number
}

variable "ebs_volume_type" {
  description = "Loại EBS volume (vd: gp3, gp2)"
  type        = string
}

variable "ebs_delete_on_termination" {
  description = "Xoá EBS khi terminate instance"
  type        = bool
}

variable "ebs_encrypted" {
  description = "Bật mã hóa EBS"
  type        = bool
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

variable "health_check_type" {
  description = "Loại health check cho ASG (EC2 hoặc ELB)"
  type        = string
}

variable "health_check_grace_period" {
  description = "Thời gian chờ trước khi áp dụng health check"
  type        = number
}

variable "app_port" {
  description = "Port ứng dụng cho phép inbound"
  type        = number
}

variable "app_cidr_blocks" {
  description = "Danh sách CIDR được phép truy cập app_port"
  type        = list(string)
}

variable "tags" {
  description = "Các tags bổ sung cho tài nguyên"
  type        = map(string)
}

# ALB
variable "alb_port" {
  description = "Port mà ALB sẽ lắng nghe"
  type        = number
}

variable "alb_protocol" {
  description = "Giao thức sử dụng cho ALB (HTTP hoặc HTTPS)"
  type        = string
}

variable "alb_cidr_blocks" {
  description = "Danh sách CIDR được phép truy cập ALB"
  type        = list(string)
}

variable "target_group_port" {
  description = "Port mà target group sẽ lắng nghe"
  type        = number
}

variable "target_group_protocol" {
  description = "Giao thức sử dụng cho target group (HTTP hoặc HTTPS)"
  type        = string
}

# RDS
variable "db_storage_type" {
  description = "Loại storage cho RDS (vd: gp3, gp2)"
  type        = string
}

variable "db_allocated_storage" {
  description = "Dung lượng storage cấp phát cho RDS (GB)"
  type        = number
}

variable "db_engine" {
  description = "Engine của database (vd: mysql, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "Phiên bản của database engine"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class cho database (vd: db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Tên database khởi tạo"
  type        = string
}

variable "db_username" {
  description = "Tên master user"
  type        = string
}

variable "db_port" {
  description = "Port kết nối tới database"
  type        = number
}
