variable "aws_region" {
  description = "Region định danh cho tài nguyên"
  type        = string
}

variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải CIDR của VPC"
  type        = string
}

variable "public_subnets" {
  description = "Bản đồ cấu hình các subnet public"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    type              = string # "alb" hoặc "nat"
  }))
  default = {}

  validation {
    condition     = alltrue([for s in var.public_subnets : contains(["alb", "nat"], s.type)])
    error_message = "Mỗi public subnet type phải là 'alb' hoặc 'nat'."
  }
}

variable "private_subnets" {
  description = "Bản đồ cấu hình các subnet private"
  type = map(object({
    cidr_block           = string
    availability_zone    = string
    type                 = string           # "app" hoặc "db"
    nat_gateway_route_to = optional(string) # Khóa của public subnet chứa NAT Gateway tương ứng, có thể null.
  }))
  default = {}

  validation {
    condition     = alltrue([for s in var.private_subnets : contains(["app", "db"], s.type)])
    error_message = "Mỗi private subnet type phải là 'app' hoặc 'db'."
  }
}


