# Gọi module S3 để tạo 2 bucket: 1 cho Frontend và 1 cho Dữ liệu CSV
module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  buckets = {
    "frontend" = {}
    "csv-data" = {}
  }
}
