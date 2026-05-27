variable "aws_region" {
  description = "Vùng AWS dùng để triển khai tài nguyên (ví dụ: us-east-1)"
  type        = string
}

variable "availability_zones" {
  description = "Danh sách các Availability Zone dùng để triển khai (ví dụ: ['us-east-1a', 'us-east-1b'])"
  type        = list(string)
}

variable "project_name" {
  description = "Tên dự án dùng để gán nhãn và làm tiền tố cho tài nguyên"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải IP của VPC"
  type        = string
}

variable "public_subnets" {
  description = "Bản đồ cấu hình các subnet public"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    type              = string # "alb" hoặc "nat"
  }))
}

variable "private_subnets" {
  description = "Bản đồ cấu hình các subnet private"
  type = map(object({
    cidr_block           = string
    availability_zone    = string
    type                 = string           # "app" hoặc "db"
    nat_gateway_route_to = optional(string) # Khóa của public subnet chứa NAT Gateway tương ứng, có thể null.
  }))
}

variable "vpc_endpoints" {
  description = "Bản đồ các VPC Endpoints cần tạo"
  type = map(object({
    service_name        = string
    vpc_endpoint_type   = string
    private_dns_enabled = optional(bool, false)
    subnet_names        = optional(list(string), [])
  }))
  default = {}
}
