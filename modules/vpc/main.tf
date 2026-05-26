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

# 2. Internet Gateway
resource "aws_internet_gateway" "main" {
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
  private_subnets_with_nat = { for k, v in var.private_subnets : k => v if v.nat_gateway_route_to != null }
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
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
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

# 9. Route Table Association (Public Subnets)
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# 10. Route Table Associations (Private Subnets)
resource "aws_route_table_association" "private" {
  for_each = local.private_subnets_with_nat

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value.nat_gateway_route_to].id
}

# =============================================================================
# VPC ENDPOINTS CHO ECR VÀ CLOUDWATCH LOGS
# =============================================================================

resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "${var.project_name}-vpce-sg"
  description = "Security group for VPC Endpoints (ECR, Logs)"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  tags = {
    Name = "${var.project_name}-vpce-sg"
  }
}

locals {
  # Lọc ID của private subnets dành cho ứng dụng (app) để gán cho các Interface Endpoints
  endpoint_subnet_ids = [for key, subnet in aws_subnet.private : subnet.id if var.private_subnets[key].type == "app"]
}

# 11. Interface Endpoint cho ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.endpoint_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${var.project_name}-vpce-ecr-api"
  }
}

# 12. Interface Endpoint cho ECR DKR
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.endpoint_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${var.project_name}-vpce-ecr-dkr"
  }
}

# 13. Interface Endpoint cho CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.endpoint_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${var.project_name}-vpce-logs"
  }
}

# 14. Gateway Endpoint cho S3 (Miễn phí giờ duy trì, ECR dùng S3 để chứa layers)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in aws_route_table.private : rt.id]

  tags = {
    Name = "${var.project_name}-vpce-s3"
  }
}
