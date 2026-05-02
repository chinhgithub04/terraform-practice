locals {
  default_tags = {
    Name      = "${var.project_name}-rds"
    ManagedBy = "Terraform"
  }
  merged_tags = merge(local.default_tags, var.tags)
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.rds_subnet_ids

  tags = local.merged_tags
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-rds-sg"
    ManagedBy = "Terraform"
  }
}

resource "random_password" "db_password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project_name}-db"
  storage_type          = var.db_storage_type
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class

  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db_password.result # self-managed

  multi_az = true
  port                   = var.db_port
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true

  tags = local.merged_tags
}

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.project_name}-db-secret"
  description = "Secret chứa thông tin kết nối RDS database"
  tags = local.merged_tags
}

resource "aws_secretsmanager_secret_version" "db_secret_val" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = aws_db_instance.this.username
    password = random_password.db_password.result
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    db_name  = aws_db_instance.this.db_name
    ConnectionStrings__DefaultConnection = format(
      "Server=%s;Port=%d;Database=%s;User=%s;Password=%s;",
      aws_db_instance.this.address,
      aws_db_instance.this.port,
      aws_db_instance.this.db_name,
      aws_db_instance.this.username,
      random_password.db_password.result
    )
  })
}

