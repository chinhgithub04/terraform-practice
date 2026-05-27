# 1. Trích xuất logic lọc danh sách Lambda duy nhất vào locals theo Quy tắc 4
locals {
  # Lọc ra danh sách các Lambda ARN duy nhất từ các routes để tránh tạo trùng quyền (Sid Collision)
  unique_lambda_arns = distinct([
    for r in var.routes : r.target_lambda_arn
  ])

  # Chuyển đổi thành map để sử dụng hiệu quả trong for_each
  unique_lambdas = {
    for arn in local.unique_lambda_arns : arn => arn
  }
}

# 2. Khởi tạo tài nguyên HTTP API Gateway
resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"

  tags = {
    Name = "${var.project_name}-api"
  }
}

# 3. Tạo CloudWatch Log Group cho Access logs
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${var.project_name}-api-logs"
  retention_in_days = 30

  tags = {
    Name = "/aws/apigateway/${var.project_name}-api-logs"
  }
}

# 4. Khởi tạo Stage của API Gateway hỗ trợ Access Logging
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      latency        = "$context.responseLatency"
    })
  }

  tags = {
    Name = "${var.project_name}-api-stage-${var.stage_name}"
  }
}

# 5. Khởi tạo Cognito JWT Authorizer (chỉ tạo nếu cung cấp Cognito Endpoint)
resource "aws_apigatewayv2_authorizer" "cognito" {
  count            = var.cognito_user_pool_endpoint != null ? 1 : 0
  api_id           = aws_apigatewayv2_api.this.id
  name             = "${var.project_name}-cognito-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = var.cognito_client_ids
    issuer   = "https://${var.cognito_user_pool_endpoint}"
  }
}

# 6. Khởi tạo Lambda Proxy Integrations dùng cho các routes
resource "aws_apigatewayv2_integration" "this" {
  for_each = var.routes

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = each.value.target_lambda_arn
  payload_format_version = "2.0" # Tiêu chuẩn cho HTTP APIs
}

# 7. Khởi tạo API Routes liên kết với các Integrations
resource "aws_apigatewayv2_route" "this" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"

  # Áp dụng xác thực nếu bật cờ và có cấu hình Cognito
  authorization_type = each.value.enable_authorizer && var.cognito_user_pool_endpoint != null ? "JWT" : "NONE"
  authorizer_id      = each.value.enable_authorizer && var.cognito_user_pool_endpoint != null ? aws_apigatewayv2_authorizer.cognito[0].id : null
}

# 8. Cấp quyền tự động cho API Gateway để kích hoạt (invoke) các Lambda Backend
resource "aws_lambda_permission" "api_gateway" {
  for_each = local.unique_lambdas

  statement_id  = "AllowAPIGatewayInvoke-${sha256(each.value)}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
