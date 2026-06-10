variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "alb_subnet_ids" {
  description = "Danh sách ID các public subnet để đặt ALB"
  type        = list(string)
}

variable "internal" {
  description = "Xác định ALB là internal hay internet-facing"
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "Danh sách các quy tắc ingress (inbound) cho Security Group của ALB"
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
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP traffic from anywhere"
    }
  ]
}

variable "egress_rules" {
  description = "Danh sách các quy tắc egress (outbound) cho Security Group của ALB"
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

variable "target_port" {
  description = "Port của Target Group"
  type        = number
  default     = 8080
}

variable "target_protocol" {
  description = "Protocol của Target Group"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Loại target (vd: ip, instance, lambda)"
  type        = string
  default     = "ip"
}

variable "health_check" {
  description = "Cấu hình health check cho Target Group"
  type = object({
    enabled             = optional(bool, true)
    path                = optional(string, "/")
    port                = optional(string, "traffic-port")
    protocol            = optional(string, "HTTP")
    timeout             = optional(number, 5)
    interval            = optional(number, 30)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
    matcher             = optional(string, "200")
  })
  default = {}
}

variable "listener_port" {
  description = "Port của listener mặc định"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol của listener mặc định (HTTP hoặc HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "ARN của SSL Certificate (chỉ dùng nếu listener_protocol là HTTPS)"
  type        = string
  default     = null
}
