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

variable "db_allocated_storage" {
  description = "Dung lượng storage cấp phát cho RDS (GB)"
  type        = number
}

variable "db_instance_class" {
  description = "Instance class cho database (vd: db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Tên database khởi tạo"
  type        = string
}

variable "app_security_group_id" {
  description = "ID của Security group app để allow truy cập vào RDS"
  type        = string
}
