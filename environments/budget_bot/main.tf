# 1. Gọi module S3 để tạo 2 bucket: 1 cho Frontend và 1 cho Dữ liệu CSV
module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  buckets = {
    "frontend" = {}
    "csv-data" = {}
  }
}

# 2. Gọi module VPC để xây dựng hạ tầng mạng riêng tư bảo mật và tái sử dụng cao
module "vpc" {
  source = "../../modules/vpc"

  aws_region      = var.aws_region
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# 2.1. Gọi module VPC Endpoint để khởi tạo kết nối riêng tư tới AWS Services (như S3, Bedrock)
module "vpc_endpoint" {
  source = "../../modules/vpc_endpoint"

  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = module.vpc.vpc_cidr
  project_name            = var.project_name
  vpc_endpoints           = var.vpc_endpoints
  private_subnet_ids      = module.vpc.private_subnet_ids_map
  private_route_table_ids = module.vpc.private_route_table_ids_map
}

# 3. Gọi module Security Group để khởi tạo nhóm bảo mật cho Lambda (IPv4 only)
module "lambda_sg" {
  source = "../../modules/security_group"

  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  sg_name_suffix = "lambda"
  description    = "Security group for application Lambda functions"
  egress_rules   = var.lambda_sg_egress_rules
}

# 4. Gọi module Lambda để khởi tạo các hàm Lambda trong VPC một cách sạch sẽ
module "lambda" {
  source = "../../modules/lambda"

  project_name           = var.project_name
  vpc_subnet_ids         = module.vpc.app_subnet_ids
  vpc_security_group_ids = [module.lambda_sg.security_group_id]
  lambdas                = var.lambdas
}

# 5. Gọi module API Gateway để tạo HTTP API định tuyến tới các Lambda một cách sạch sẽ
module "api_gateway" {
  source = "../../modules/api_gateway"

  project_name = var.project_name
  stage_name   = "$default"
  lambda_arns  = module.lambda.lambda_arns
  routes       = var.api_gateway_routes
}

# 6. Gọi module RDS để khởi tạo cơ sở dữ liệu Single AZ tiết kiệm chi phí
module "rds" {
  source = "../../modules/rds"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  rds_subnet_ids        = module.vpc.rds_subnet_ids
  db_allocated_storage  = var.rds_db_allocated_storage
  db_instance_class     = var.rds_db_instance_class
  db_name               = var.rds_db_name
  app_security_group_id = module.lambda_sg.security_group_id
  multi_az              = var.rds_multi_az
}

