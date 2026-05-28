variable "project_name" {
  description = "Tên dự án dùng để gán Name tag và định danh tài nguyên"
  type        = string
}

variable "lambdas" {
  description = "Bản đồ cấu hình chi tiết cho các hàm Lambda cần tạo. Key là định danh của hàm Lambda."
  type = map(object({
    handler                = string
    runtime                = string
    memory_size            = optional(number, 128)
    timeout                = optional(number, 3)
    environment_variables  = optional(map(string), {})
    vpc_subnet_ids         = optional(list(string), null)
    vpc_security_group_ids = optional(list(string), null)
    s3_bucket              = optional(string, null)
    s3_key                 = optional(string, null)
    source_dir             = optional(string, null)
    local_zip_path         = optional(string, null)
    iam_policy_statements = optional(list(object({
      effect    = string
      actions   = list(string)
      resources = list(string)
    })), [])
  }))
}

variable "vpc_subnet_ids" {
  description = "Danh sách ID các private subnets dùng chung cho tất cả các Lambda (có thể ghi đè ở từng lambda)"
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "Danh sách ID các security groups dùng chung cho tất cả các Lambda (có thể ghi đè ở từng lambda)"
  type        = list(string)
  default     = null
}
