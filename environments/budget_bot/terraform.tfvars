aws_region         = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]
project_name       = "budget-bot"

vpc_cidr = "10.0.0.0/16"

public_subnets = {}

# Phân tách rõ ràng subnets cho Application (Lambda) và Database (RDS) theo tiêu chuẩn bảo mật
private_subnets = {
  "private-app-a" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    type              = "app" # Subnet riêng tư cho các hàm Lambda (Chat & CSV parser)
  }
  "private-app-b" = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    type              = "app" # Subnet riêng tư dự phòng cho Application
  }
  "private-db-a" = {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    type              = "db" # Subnet riêng tư cho cơ sở dữ liệu RDS (Single AZ chạy tại đây)
  }
  "private-db-b" = {
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    type              = "db" # Subnet riêng tư dự phòng phục vụ RDS DB Subnet Group bắt buộc
  }
}

# Cấu hình các VPC Endpoints động và cực kỳ tiết kiệm chi phí
vpc_endpoints = {
  "s3" = {
    service_name      = "com.amazonaws.us-east-1.s3"
    vpc_endpoint_type = "Gateway"
  }
  "bedrock-runtime" = {
    service_name        = "com.amazonaws.us-east-1.bedrock-runtime"
    vpc_endpoint_type   = "Interface"
    private_dns_enabled = true
    subnet_names        = ["private-app-a"] # Tiết kiệm 50% chi phí: chỉ triển khai Endpoint ở 1 AZ (us-east-1a)
  }
}
