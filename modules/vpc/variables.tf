variable "availability_zones" {
  description = "AZ to deploy resources"
  type        = list(string)
}

variable "project_name" {
  description = "Tên dự án để gán tag"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải IP của VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnets configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnet_cidrs" {
  type = list(string)
}

