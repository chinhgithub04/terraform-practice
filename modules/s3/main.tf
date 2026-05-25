resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-frontend-code"

  tags = {
    Name = "${var.project_name}-frontend-code"
  }
}
