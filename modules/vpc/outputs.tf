output "vpc_id" {
  description = "ID của VPC vừa tạo"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Danh sách ID của các subnet public"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Danh sách ID của các private subnets"
  value       = aws_subnet.private[*].id
}

output "igw_id" {
  description = "ID của Internet Gateway"
  value       = aws_internet_gateway.main.id
}
