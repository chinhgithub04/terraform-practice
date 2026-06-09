locals {
  alb_subnet_ids     = [for k, subnet in aws_subnet.public : subnet.id if var.public_subnets[k].type == "alb"]
  private_subnet_ids = [for subnet in aws_subnet.private : subnet.id]
  app_subnet_ids     = [for key, subnet in aws_subnet.private : subnet.id if var.private_subnets[key].type == "app"]
  rds_subnet_ids     = [for key, subnet in aws_subnet.private : subnet.id if var.private_subnets[key].type == "db"]
}

output "vpc_id" {
  description = "ID của VPC vừa tạo"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "Dải CIDR của VPC"
  value       = aws_vpc.this.cidr_block
}

output "alb_subnet_ids" {
  description = "Danh sách ID của các subnet public dùng cho ALB"
  value       = local.alb_subnet_ids
}

output "private_subnet_ids" {
  description = "Danh sách ID của tất cả các subnet private"
  value       = local.private_subnet_ids
}

output "app_subnet_ids" {
  description = "Danh sách ID của các subnet private dùng cho ứng dụng"
  value       = local.app_subnet_ids
}

output "rds_subnet_ids" {
  description = "Danh sách ID của các subnet private dùng cho RDS"
  value       = local.rds_subnet_ids
}

output "igw_id" {
  description = "ID của Internet Gateway"
  value       = length(aws_internet_gateway.main) > 0 ? aws_internet_gateway.main[0].id : null
}

output "private_subnet_ids_map" {
  description = "Bản đồ ID của các subnet private theo key"
  value       = { for k, s in aws_subnet.private : k => s.id }
}

output "private_route_table_ids_map" {
  description = "Bản đồ ID của các private route table theo key"
  value       = { for k, rt in aws_route_table.private : k => rt.id }
}

