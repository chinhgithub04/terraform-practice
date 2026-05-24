resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1 # Độ ưu tiên (1 là cao nhất)
        description  = "Chỉ giữ lại 10 image mới nhất"
        selection = {
          tagStatus   = "any"                # Áp dụng cho tất cả các image (có tag hoặc không tag)
          countType   = "imageCountMoreThan" # Điều kiện kích hoạt: dựa trên số lượng
          countNumber = 10                   # Số lượng image tối đa được giữ lại
        }
        action = {
          type = "expire" # Hành động: xóa bỏ
        }
      }
    ]
  })
}
