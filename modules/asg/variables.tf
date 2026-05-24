variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC dùng để tạo security group"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID của Security Group ALB để cho phép kết nối vào ASG"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Tên của ECS Cluster để EC2 đăng ký vào"
  type        = string
}

variable "private_subnet_ids" {
  description = "Danh sách private subnet IDs cho ASG"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID cho EC2 instances trong ASG"
  type        = string
}

variable "instance_type" {
  description = "Loại EC2 instance"
  type        = string
}

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
