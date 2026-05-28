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
  description = "Bản đồ các VPC Endpoints cần tạo"
  type = map(object({
    service_name        = string
    vpc_endpoint_type   = string
    private_dns_enabled = optional(bool, false)
    subnet_names        = optional(list(string), [])
  }))
  default = {}
}

variable "lambda_sg_egress_rules" {
  description = "Danh sách các luật egress cho Lambda Security Group (IPv4 outbound)"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
}

variable "lambdas_config" {
  description = "Bản đồ cấu hình chi tiết cho các hàm Lambda cần tạo"
  type = map(object({
    handler     = string
    runtime     = string
    memory_size = number
    timeout     = number
  }))
}

variable "api_gateway_routes" {
  description = "Bản đồ cấu hình các routes cho API Gateway"
  type = map(object({
    route_key = string
  }))
}

variable "rds_db_allocated_storage" {
  description = "Dung lượng storage cấp phát cho RDS (GB)"
  type        = number
}

variable "rds_db_instance_class" {
  description = "Instance class cho database (vd: db.t3.micro)"
  type        = string
}

variable "rds_db_name" {
  description = "Tên database khởi tạo"
  type        = string
}

variable "rds_multi_az" {
  description = "Bật/Tắt chế độ Multi-AZ cho RDS"
  type        = bool
}
