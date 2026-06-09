locals {
  # Phân loại endpoints thô để xác định điều kiện tạo Security Group
  interface_endpoints = { for k, v in var.vpc_endpoints : k => v if v.vpc_endpoint_type == "Interface" }
  create_vpce_sg      = length(local.interface_endpoints) > 0
}

# Security Group dùng chung cho toàn bộ Interface Endpoints
resource "aws_security_group" "vpc_endpoints" {
  count       = local.create_vpce_sg ? 1 : 0
  name        = "${var.project_name}-vpce-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound IPv4 traffic from endpoints"
  }

  tags = {
    Name = "${var.project_name}-vpce-sg"
  }
}

# Khởi tạo các Gateway Endpoints (ví dụ: S3)
resource "aws_vpc_endpoint" "gateway" {
  for_each          = { for k, v in var.vpc_endpoints : k => v if v.vpc_endpoint_type == "Gateway" }
  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rk in each.value.route_table_keys : var.private_route_table_ids[rk]]

  tags = {
    Name = "${var.project_name}-vpce-${each.key}"
  }
}

# Khởi tạo các Interface Endpoints (ví dụ: Bedrock, ECR)
resource "aws_vpc_endpoint" "interface" {
  for_each            = local.interface_endpoints
  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = each.value.private_dns_enabled
  subnet_ids          = [for sk in each.value.subnet_keys : var.private_subnet_ids[sk]]
  security_group_ids  = local.create_vpce_sg ? [aws_security_group.vpc_endpoints[0].id] : []

  tags = {
    Name = "${var.project_name}-vpce-${each.key}"
  }
}
