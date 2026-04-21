output "vpc_id" {
  description = "ID của VPC vừa tạo"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}
