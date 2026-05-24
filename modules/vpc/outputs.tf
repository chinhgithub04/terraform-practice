output "vpc_id" {
  description = "ID của VPC vừa tạo"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Danh sách ID của các subnet public"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "Danh sách ID của các private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "app_subnet_ids" {
  description = "Danh sách ID của các subnet private dùng cho ứng dụng"
  value       = [for key, subnet in aws_subnet.private : subnet.id if var.private_subnets[key].type == "app"]
}

output "rds_subnet_ids" {
  description = "Danh sách ID của các subnet private dùng cho RDS"
  value       = [for key, subnet in aws_subnet.private : subnet.id if var.private_subnets[key].type == "db"]
}

output "igw_id" {
  description = "ID của Internet Gateway"
  value       = aws_internet_gateway.main.id
}
