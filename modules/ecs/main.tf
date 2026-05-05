locals {
  default_tags = {
    Name      = "${var.project_name}-ecs"
    ManagedBy = "Terraform"
  }
  merged_tags = merge(local.default_tags, var.tags)
}

resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name

  setting {
    name = "containerInsights" # Gửi metrics và logs của ECS cluster đến CloudWatch
    value = "enabled"
  }
  
  tags = local.merged_tags
}

resource "aws_ecs_capacity_provider" "this" {
  name = "${var.project_name}-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arn
    managed_termination_protection = var.managed_termination_protection

    managed_scaling {
      minimum_scaling_step_size = 1 # Mỗi lần tăng/giảm tối thiểu bao nhiêu máy chủ
      maximum_scaling_step_size = 10 # Mỗi lần tăng/giảm tối đa bao nhiêu máy chủ
      status          = var.managed_scaling_status
      target_capacity = var.target_capacity
    }
  }

  tags = local.merged_tags
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [
    aws_ecs_capacity_provider.this.name
  ]

  default_capacity_provider_strategy {
    base              = 1 # Số lượng máy chủ tối thiểu luôn chạy trong capacity provider này
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}
