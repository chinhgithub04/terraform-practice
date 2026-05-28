locals {
  # Lọc các lambda sử dụng thư mục nguồn cục bộ để tiến hành nén tự động
  lambdas_with_source_dir = {
    for k, v in var.lambdas : k => v if v.source_dir != null
  }

  # Lọc các lambda được chỉ định chạy trong VPC (cá nhân hoặc dùng chung cấp module)
  lambdas_in_vpc = {
    for k, v in var.lambdas : k => v if(v.vpc_subnet_ids != null && length(v.vpc_subnet_ids) > 0) || (var.vpc_subnet_ids != null && length(var.vpc_subnet_ids) > 0)
  }

  # Lọc các lambda có định nghĩa các quyền hạn IAM tùy chỉnh (custom IAM statements)
  lambdas_with_custom_policies = {
    for k, v in var.lambdas : k => v if v.iam_policy_statements != null && length(v.iam_policy_statements) > 0
  }

  # Tính toán hash của local zip path một cách an toàn để tránh gọi filebase64sha256(null)
  local_zip_hashes = {
    for k, v in var.lambdas : k => filebase64sha256(v.local_zip_path) if v.local_zip_path != null
  }
}

# 1. Tự động đóng gói thư mục code cục bộ thành file .zip nếu được chỉ định
data "archive_file" "lambda_zip" {
  for_each    = local.lambdas_with_source_dir
  type        = "zip"
  source_dir  = each.value.source_dir
  output_path = "${path.module}/files/${each.key}_payload.zip"
}

# 2. Tạo IAM Role riêng biệt cho mỗi hàm Lambda
resource "aws_iam_role" "lambda_role" {
  for_each = var.lambdas

  name = "${var.project_name}-lambda-role-${each.key}"

  # IAM Trust Policy (Invariant parameter) được định nghĩa tĩnh trong module
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-lambda-role-${each.key}"
  }
}

# 3. Đính kèm Basic Execution Role Policy (Ghi logs vào CloudWatch) cho tất cả các Lambda
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  for_each   = var.lambdas
  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 4. Tự động đính kèm VPC Execution Role Policy nếu Lambda được thiết lập trong VPC
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  for_each   = local.lambdas_in_vpc
  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# 5. Tạo và đính kèm Custom IAM Policies nếu được chỉ định trong cấu hình
resource "aws_iam_policy" "custom_policy" {
  for_each = local.lambdas_with_custom_policies
  name     = "${var.project_name}-lambda-policy-${each.key}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for stmt in each.value.iam_policy_statements : {
        Effect   = stmt.effect
        Action   = stmt.actions
        Resource = stmt.resources
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-lambda-policy-${each.key}"
  }
}

resource "aws_iam_role_policy_attachment" "custom_attachment" {
  for_each   = local.lambdas_with_custom_policies
  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = aws_iam_policy.custom_policy[each.key].arn
}

# 6. Khởi tạo tài nguyên Lambda Function bằng for_each
resource "aws_lambda_function" "this" {
  for_each = var.lambdas

  function_name = "${var.project_name}-${each.key}"
  handler       = each.value.handler
  runtime       = each.value.runtime
  memory_size   = each.value.memory_size
  timeout       = each.value.timeout
  role          = aws_iam_role.lambda_role[each.key].arn

  # Xác định nguồn gói code một cách linh hoạt
  s3_bucket        = each.value.s3_bucket
  s3_key           = each.value.s3_key
  filename         = each.value.source_dir != null ? data.archive_file.lambda_zip[each.key].output_path : (each.value.local_zip_path != null ? each.value.local_zip_path : null)
  source_code_hash = each.value.source_dir != null ? data.archive_file.lambda_zip[each.key].output_base64sha256 : (each.value.local_zip_path != null ? local.local_zip_hashes[each.key] : null)

  # Cấu hình biến môi trường động
  dynamic "environment" {
    for_each = each.value.environment_variables != null && length(each.value.environment_variables) > 0 ? [1] : []
    content {
      variables = each.value.environment_variables
    }
  }

  # Cấu hình VPC động
  dynamic "vpc_config" {
    for_each = (each.value.vpc_subnet_ids != null || var.vpc_subnet_ids != null) && (each.value.vpc_security_group_ids != null || var.vpc_security_group_ids != null) ? [1] : []
    content {
      subnet_ids         = each.value.vpc_subnet_ids != null ? each.value.vpc_subnet_ids : var.vpc_subnet_ids
      security_group_ids = each.value.vpc_security_group_ids != null ? each.value.vpc_security_group_ids : var.vpc_security_group_ids
    }
  }

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}
