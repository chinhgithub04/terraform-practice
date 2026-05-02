output "ecr_repository_url" {
  description = "URL của ECR repository để push/pull images"
  value       = aws_ecr_repository.this.repository_url
}

output "ecr_repository_arn" {
  description = "ARN của ECR repository"
  value       = aws_ecr_repository.this.arn
}

output "ecr_repository_name" {
  description = "Tên của ECR repository"
  value       = aws_ecr_repository.this.name
}
