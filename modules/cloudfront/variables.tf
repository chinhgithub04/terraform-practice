variable "project_name" {
  description = "Tên dự án dùng để gán Name tag và định danh tài nguyên"
  type        = string
}

variable "s3_origins" {
  description = "Bản đồ các S3 origins (ví dụ: frontend, assets). Khóa là origin_id."
  type = map(object({
    domain_name = string
    bucket_id   = string
    bucket_arn  = string
  }))
  default = {}
}

variable "custom_origins" {
  description = "Bản đồ các custom origins (ví dụ: Application Load Balancer). Khóa là origin_id."
  type = map(object({
    domain_name            = string
    origin_protocol_policy = optional(string, "http-only") # "http-only", "https-only", "match-viewer"
  }))
  default = {}
}

variable "default_cache_behavior" {
  description = "Cấu hình cache behavior mặc định"
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = optional(string, "redirect-to-https")
    allowed_methods        = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods         = optional(list(string), ["GET", "HEAD"])
    compress               = optional(bool, true)
    default_ttl            = optional(number, 86400)
    min_ttl                = optional(number, 0)
    max_ttl                = optional(number, 31536000)
  })
}

variable "ordered_cache_behaviors" {
  description = "Danh sách các cache behavior theo thứ tự ưu tiên (ví dụ: định tuyến /api/* tới ALB)"
  type = list(object({
    path_pattern           = string
    target_origin_id       = string
    viewer_protocol_policy = optional(string, "redirect-to-https")
    allowed_methods        = optional(list(string), ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])
    cached_methods         = optional(list(string), ["GET", "HEAD"])
    compress               = optional(bool, true)
    default_ttl            = optional(number, 0)
    min_ttl                = optional(number, 0)
    max_ttl                = optional(number, 0)
    query_string           = optional(bool, true)
    headers                = optional(list(string), ["*"])
    cookies_forward        = optional(string, "all") # "all", "none"
  }))
  default = []
}

variable "custom_error_responses" {
  description = "Cấu hình phản hồi lỗi tùy chỉnh (phù hợp cho Single Page Applications)"
  type = list(object({
    error_code            = number
    response_code         = optional(number, 200)
    response_page_path    = optional(string, "/index.html")
    error_caching_min_ttl = optional(number, 10)
  }))
  default = [
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]
}

variable "aliases" {
  description = "Danh sách các tên miền tùy chỉnh (CNAMEs) cho CloudFront"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN của chứng chỉ SSL từ AWS Certificate Manager (ACM). Lưu ý: ACM phải nằm ở vùng us-east-1."
  type        = string
  default     = null
}
