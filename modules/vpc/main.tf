# 1. VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# 2. Internet Gateway (Chỉ tạo nếu có Public Subnets)
resource "aws_internet_gateway" "main" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# 3. Public Subnets
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

# 4. Private Subnets
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

# =============================================================================
# NAT GATEWAY & ĐỊNH TUYẾN PRIVATE SUBNETS
# =============================================================================

locals {
  nat_subnets              = { for k, v in var.public_subnets : k => v if v.type == "nat" }
  private_subnets_with_nat = { for k, v in var.private_subnets : k => v if v.nat_gateway_route_to != null && length(local.nat_subnets) > 0 }
  app_private_subnets      = { for k, v in var.private_subnets : k => v if v.type == "app" }
  db_private_subnets       = { for k, v in var.private_subnets : k => v if v.type == "db" }
}

# 5. Elastic IPs cho các NAT Gateway (chỉ tạo ở subnet public có type là "nat")
resource "aws_eip" "nat" {
  for_each = local.nat_subnets
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-${each.key}"
  }
}

# 6. NAT Gateways (chỉ tạo ở subnet public có type là "nat")
resource "aws_nat_gateway" "this" {
  for_each      = local.nat_subnets
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.project_name}-nat-gw-${each.key}"
  }
}

# 7. Route Table cho Public Subnets
resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# 8. Route Tables cho Private Subnets (mỗi NAT Gateway có 1 route table riêng)
resource "aws_route_table" "private" {
  for_each = local.nat_subnets
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${each.key}"
  }
}

# Kịch bản B: Không có NAT Gateways nhưng có Private Subnets -> Tạo Route Tables tách biệt cho App (để đi S3) và DB (cô lập hoàn toàn)
resource "aws_route_table" "private_app_no_nat" {
  count  = length(local.nat_subnets) == 0 && length(local.app_private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-private-app-rt"
  }
}

resource "aws_route_table" "private_db_no_nat" {
  count  = length(local.nat_subnets) == 0 && length(local.db_private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-private-db-rt"
  }
}

# 9. Route Table Association (Public Subnets)
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

# 10. Route Table Associations (Private Subnets)
# Trường hợp có NAT Gateway:
resource "aws_route_table_association" "private" {
  for_each = local.private_subnets_with_nat

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value.nat_gateway_route_to].id
}

# Trường hợp không có NAT Gateway:
resource "aws_route_table_association" "private_app_no_nat" {
  for_each = length(local.nat_subnets) == 0 ? local.app_private_subnets : {}

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_app_no_nat[0].id
}

resource "aws_route_table_association" "private_db_no_nat" {
  for_each = length(local.nat_subnets) == 0 ? local.db_private_subnets : {}

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_db_no_nat[0].id
}

# =============================================================================
# CẤU HÌNH VPC ENDPOINTS TỔNG QUÁT (GENERIC VPC ENDPOINTS)
# =============================================================================

locals {
  interface_endpoints = { for k, v in var.vpc_endpoints : k => v if v.vpc_endpoint_type == "Interface" }
  create_vpce_sg      = length(local.interface_endpoints) > 0
}

# Security Group dùng chung cho toàn bộ Interface Endpoints
resource "aws_security_group" "vpc_endpoints" {
  count       = local.create_vpce_sg ? 1 : 0
  name        = "${var.project_name}-vpce-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
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

# Khởi tạo động toàn bộ các Gateway / Interface Endpoints qua bản đồ vpc_endpoints
resource "aws_vpc_endpoint" "this" {
  for_each = var.vpc_endpoints

  vpc_id            = aws_vpc.this.id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type

  # Cấu hình cụ thể cho Interface Endpoints (ví dụ: Bedrock, ECR, CloudWatch Logs)
  private_dns_enabled = each.value.vpc_endpoint_type == "Interface" ? each.value.private_dns_enabled : null
  subnet_ids          = each.value.vpc_endpoint_type == "Interface" ? [for name in each.value.subnet_names : aws_subnet.private[name].id] : null
  security_group_ids  = each.value.vpc_endpoint_type == "Interface" ? [aws_security_group.vpc_endpoints[0].id] : null

  # Cấu hình cụ thể cho Gateway Endpoints (ví dụ: S3)
  route_table_ids = each.value.vpc_endpoint_type == "Gateway" ? concat(
    length(var.public_subnets) > 0 ? [aws_route_table.public[0].id] : [],
    length(local.nat_subnets) > 0 ? [for rt in aws_route_table.private : rt.id] : [],
    length(local.nat_subnets) == 0 && length(local.app_private_subnets) > 0 ? [aws_route_table.private_app_no_nat[0].id] : []
  ) : null

  tags = {
    Name = "${var.project_name}-vpce-${each.key}"
  }
}
