output "vpc_id" {
  description = "ID của VPC vừa tạo"
  value       = module.vpc.vpc_id
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
