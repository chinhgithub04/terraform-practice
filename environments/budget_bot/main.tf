# 1. Gọi module S3 để tạo 2 bucket: 1 cho Frontend và 1 cho Dữ liệu CSV
module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  buckets = {
    "frontend" = {}
    "csv-data" = {}
  }
}

# 2. Gọi module VPC để xây dựng hạ tầng mạng sạch sẽ và tái sử dụng tốt nhất
module "vpc" {
  source = "../../modules/vpc"

  aws_region         = var.aws_region
  project_name       = var.project_name
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  vpc_endpoints      = var.vpc_endpoints
}
