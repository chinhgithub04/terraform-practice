output "vpc_id" {
  description = "ID của VPC vừa tạo"
  value       = module.vpc.vpc_id
}
output "alb_dns_name" {
  description = "DNS name của ALB để truy cập ứng dụng"
  value       = module.alb.alb_dns_name
}

output "rds_db_endpoint" {
  description = "Connection endpoint của RDS database (đã bao gồm port)"
  value       = module.rds.rds_db_endpoint
}
output "vpc_cidr" {
  description = "CIDR block của VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Danh sách ID của các subnet public"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Danh sách ID của các private subnets"
  value       = module.vpc.private_subnet_ids
}

output "igw_id" {
  description = "ID của Internet Gateway"
  value       = module.vpc.igw_id
}
