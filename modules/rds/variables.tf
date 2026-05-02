variable "project_name" {
  description = "Tên dự án"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC để deploy RDS"
  type        = string
}

variable "rds_subnet_ids" {
  description = "Danh sách ID các private subnet để đặt RDS DB subnet group"
  type        = list(string)
}

variable "db_storage_type" {
  description = "Loại storage cho RDS (vd: gp2, gp3)"
  type        = string
}

variable "db_allocated_storage" {
  description = "Dung lượng storage cấp phát cho RDS (GB)"
  type        = number
}

variable "db_engine" {
  description = "Engine của database (vd: mysql, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "Phiên bản của database engine"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class cho database (vd: db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Tên database khởi tạo"
  type        = string
}

variable "db_username" {
  description = "Tên master user"
  type        = string
}

variable "db_port" {
  description = "Port kết nối tới database"
  type        = number
}

variable "app_security_group_id" {
  description = "ID của Security group app để allow truy cập vào RDS"
  type        = string
}

variable "tags" {
  description = "Tags áp dụng cho tất cả resources"
  type        = map(string)
  default     = {}
}
