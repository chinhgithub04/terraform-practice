variable "aws_region" {
  description = "Region định danh cho tài nguyên"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "AZ to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
  default     = "xbrain-project"
}

variable "vpc_cidr" {
  description = "Dải IP của VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
