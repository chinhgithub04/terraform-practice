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

variable "target_group_arns" {
  description = "Danh sách ARN của target groups để attach vào ASG"
  type        = list(string)
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
