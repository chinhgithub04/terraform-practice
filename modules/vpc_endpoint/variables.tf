variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải CIDR của VPC dùng cho Security Group"
  type        = string
}

variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "vpc_endpoints" {
  description = "Bản đồ các VPC Endpoints cần tạo. Hỗ trợ cả Gateway Endpoints (như S3) và Interface Endpoints (như Bedrock, ECR)."
  type = map(object({
    service_name        = string                     # Tên dịch vụ AWS đầy đủ (ví dụ: com.amazonaws.us-east-1.s3)
    vpc_endpoint_type   = string                     # "Gateway" hoặc "Interface"
    private_dns_enabled = optional(bool, false)      # Kích hoạt Private DNS (chỉ áp dụng cho Interface Endpoint)
    subnet_keys         = optional(list(string), []) # Danh sách các khóa public/private subnets để đặt endpoint (chỉ áp dụng cho Interface Endpoint)
    route_table_keys    = optional(list(string), []) # Danh sách các khóa route table để định tuyến tới Gateway Endpoint (chỉ áp dụng cho Gateway Endpoint)
  }))
  default = {}

  validation {
    condition     = alltrue([for e in var.vpc_endpoints : contains(["Gateway", "Interface"], e.vpc_endpoint_type)])
    error_message = "Mỗi vpc_endpoint_type phải là 'Gateway' hoặc 'Interface'."
  }
}

variable "private_subnet_ids" {
  description = "Bản đồ ánh xạ khóa private subnet sang ID tương ứng"
  type        = map(string)
  default     = {}
}

variable "private_route_table_ids" {
  description = "Bản đồ ánh xạ khóa private route table sang ID tương ứng"
  type        = map(string)
  default     = {}
}
