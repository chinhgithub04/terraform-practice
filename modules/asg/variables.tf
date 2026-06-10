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
  default     = {}
}

variable "ingress_rules" {
  description = "Danh sách các ingress rules tùy chỉnh cho ASG. Nếu để trống, mặc định sẽ cho phép port 8080 từ alb_security_group_id."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    description     = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Danh sách các egress rules cho ASG"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    description     = optional(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}

variable "volume_size" {
  description = "Dung lượng ổ đĩa root (GB)"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "Loại ổ đĩa root"
  type        = string
  default     = "gp3"
}

variable "health_check_type" {
  description = "Loại health check cho ASG (EC2 hoặc ELB)"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Thời gian grace period cho health check (giây)"
  type        = number
  default     = 300
}

variable "protect_from_scale_in" {
  description = "Bảo vệ các instances khỏi bị scale in tự động"
  type        = bool
  default     = true
}

variable "user_data_base64" {
  description = "Mã hóa base64 của User Data script. Nếu được cung cấp, sẽ ghi đè script mặc định."
  type        = string
  default     = null
}

variable "additional_iam_policies" {
  description = "Danh sách các ARN IAM Policy bổ sung cần attach vào EC2 role"
  type        = list(string)
  default     = []
}
