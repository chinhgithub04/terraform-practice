variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC dùng để tạo security group"
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
  description = "Xóa EBS khi terminate instance"
  type        = bool
}

variable "ebs_encrypted" {
  description = "Bật mã hóa EBS"
  type        = bool
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
  default     = 1
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

variable "iam_instance_profile_name" {
  description = "Tên IAM instance profile gắn vào EC2 (optional)"
  type        = string
}

variable "tags" {
  description = "Các tags bổ sung cho tài nguyên"
  type        = map(string)
}
