resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket = "${var.project_name}-${each.key}"

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}
