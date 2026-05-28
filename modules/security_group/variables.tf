variable "project_name" {
  description = "Tên dự án dùng để gán Name tag và định danh tài nguyên"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC nơi nhóm bảo mật được khởi tạo"
  type        = string
}

variable "sg_name_suffix" {
  description = "Hậu tố tên nhóm bảo mật (ví dụ: lambda, rds)"
  type        = string
}

variable "description" {
  description = "Mô tả của nhóm bảo mật"
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Danh sách các luật inbound (ingress) chi tiết"
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
  description = "Danh sách các luật outbound (egress) chi tiết"
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
