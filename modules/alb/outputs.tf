output "alb_target_group_arn" {
  description = "ARN của target group"
  value       = aws_lb_target_group.app.arn
}

output "alb_target_group_name" {
  description = "Tên của target group"
  value       = aws_lb_target_group.app.name
}

output "alb_target_group_id" {
  description = "ID của target group"
  value       = aws_lb_target_group.app.id
}

output "alb_target_group_port" {
  description = "Port của target group"
  value       = aws_lb_target_group.app.port
}

output "alb_dns_name" {
  description = "DNS name của ALB"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ARN của ALB"
  value       = aws_lb.this.arn
}
