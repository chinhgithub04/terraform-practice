output "asg_id" {
  description = "ID của Auto Scaling Group"
  value       = aws_autoscaling_group.this.id
}

output "asg_name" {
  description = "Tên của Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "asg_arn" {
  description = "ARN của Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "launch_template_id" {
  description = "ID của Launch Template"
  value       = aws_launch_template.this.id
}

output "instance_security_group_id" {
  description = "ID của security group gắn cho instances"
  value       = aws_security_group.asg.id
}
