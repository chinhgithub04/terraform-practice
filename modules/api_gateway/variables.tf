variable "project_name" {
  description = "Tên dự án dùng để gán Name tag và định danh tài nguyên"
  type        = string
}

variable "stage_name" {
  description = "Tên của API Gateway Stage (ví dụ: $default, dev, prod)"
  type        = string
  default     = "$default"
}

variable "cognito_user_pool_endpoint" {
  description = "Endpoint của Cognito User Pool dùng để xác thực JWT (để trống nếu không sử dụng Cognito)"
  type        = string
  default     = null
}

variable "cognito_client_ids" {
  description = "Danh sách Client IDs được phép xác thực thông qua API Gateway JWT"
  type        = list(string)
  default     = []
}

variable "routes" {
  description = "Bản đồ các routes cấu hình cho API Gateway. Key là định danh duy nhất (ví dụ: get_users, create_order)."
  type = map(object({
    route_key         = string # Ví dụ: "GET /users", "POST /orders", "ANY /"
    target_lambda_arn = string # ARN của Lambda function phục vụ route này
    enable_authorizer = optional(bool, false)
  }))
  default = {}
}
