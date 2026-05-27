# 1. Khởi tạo tài nguyên Cognito User Pool
resource "aws_cognito_user_pool" "this" {
  name = "${var.project_name}-user-pool"

  # Cho phép người dùng đăng nhập bằng Email làm Username
  username_attributes      = ["email"]
  auto_verified_attributes = var.auto_verified_attributes

  # Cấu hình chính sách mật khẩu bảo mật
  password_policy {
    minimum_length    = var.password_min_length
    require_lowercase = var.password_require_lowercase
    require_uppercase = var.password_require_uppercase
    require_numbers   = var.password_require_numbers
    require_symbols   = var.password_require_symbols
  }

  # Cấu hình tin nhắn xác thực đăng ký qua Email
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = var.email_verification_message
    email_subject        = var.email_verification_subject
  }

  # Cấu hình đăng ký tự phục vụ (Self Sign-Up)
  admin_create_user_config {
    allow_admin_create_user_only = !var.allow_self_sign_up
  }

  # Định nghĩa schema cho thuộc tính Email bắt buộc
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 5
      max_length = 256
    }
  }

  tags = {
    Name = "${var.project_name}-user-pool"
  }
}

# 2. Khởi tạo tài nguyên Cognito User Pool Client bằng for_each
resource "aws_cognito_user_pool_client" "this" {
  for_each = var.clients

  name         = "${var.project_name}-client-${each.key}"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret                      = each.value.generate_secret
  explicit_auth_flows                  = each.value.explicit_auth_flows
  supported_identity_providers         = each.value.supported_identity_providers
  callback_urls                        = each.value.callback_urls
  logout_urls                          = each.value.logout_urls
  allowed_oauth_flows                  = each.value.allowed_oauth_flows
  allowed_oauth_scopes                 = each.value.allowed_oauth_scopes
  allowed_oauth_flows_user_pool_client = each.value.allowed_oauth_flows_user_pool_client
}

# 3. Đăng ký tên miền cho Cognito Hosted UI (nếu có yêu cầu)
resource "aws_cognito_user_pool_domain" "this" {
  count        = var.domain_prefix != null ? 1 : 0
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.this.id
}
