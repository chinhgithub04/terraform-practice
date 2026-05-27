variable "aws_region" {
  description = "Region định danh cho tài nguyên"
  type        = string
}

variable "availability_zones" {
  description = "Danh sách các Availability Zones để triển khai tài nguyên"
  type        = list(string)
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
}

variable "vpc_endpoints" {
  description = "Bản đồ các VPC Endpoints cần tạo. Hỗ trợ cả Gateway Endpoints (như S3) và Interface Endpoints (như Bedrock, ECR)."
  type = map(object({
    service_name        = string                     # Tên dịch vụ AWS đầy đủ (ví dụ: com.amazonaws.us-east-1.s3)
    vpc_endpoint_type   = string                     # "Gateway" hoặc "Interface"
    private_dns_enabled = optional(bool, false)      # Kích hoạt Private DNS (chỉ áp dụng cho Interface Endpoint)
    subnet_names        = optional(list(string), []) # Danh sách các khóa private subnets để đặt endpoint (chỉ áp dụng cho Interface Endpoint)
  }))
  default = {}
}
