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

  aws_region         = var.aws_region
  project_name       = var.project_name
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  vpc_endpoints      = var.vpc_endpoints
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

# 4. Gọi module Lambda để khởi tạo 2 con Lambda chạy Python trong VPC thông qua vòng lặp động
module "lambda" {
  source = "../../modules/lambda"

  project_name = var.project_name
  lambdas = {
    for k, v in var.lambdas_config : k => {
      handler                = v.handler
      runtime                = v.runtime
      memory_size            = v.memory_size
      timeout                = v.timeout
      source_dir             = "${path.module}/src/${k}"
      vpc_subnet_ids         = module.vpc.app_subnet_ids
      vpc_security_group_ids = [module.lambda_sg.security_group_id]
    }
  }
}

# 5. Gọi module API Gateway để tạo HTTP API định tuyến tới các Lambda thông qua vòng lặp động
module "api_gateway" {
  source = "../../modules/api_gateway"

  project_name = var.project_name
  stage_name   = "$default"
  routes = {
    for k, v in var.api_gateway_routes : k => {
      route_key         = v.route_key
      target_lambda_arn = module.lambda.lambda_arns[k]
    }
  }
}
