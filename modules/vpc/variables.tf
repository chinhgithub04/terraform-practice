variable "availability_zones" {
  description = "Danh sách các Availability Zones để triển khai tài nguyên"
  type        = list(string)
}

variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải IP của VPC"
  type        = string
}

variable "public_subnets" {
  description = "Bản đồ cấu hình các subnet public (chia rõ loại cho ALB hoặc NAT Gateway)"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    type              = string # "alb" hoặc "nat"
  }))
}

variable "private_subnets" {
  description = "Bản đồ cấu hình các subnet private và chỉ định rõ khóa NAT Gateway để định tuyến ra internet"
  type = map(object({
    cidr_block           = string
    availability_zone    = string
    type                 = string           # "app" hoặc "db"
    nat_gateway_route_to = optional(string) # AZ của public subnet chứa NAT Gateway tương ứng, có thể null.
  }))
}
