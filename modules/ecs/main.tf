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
    name  = "containerInsights" # Gửi metrics và logs của ECS cluster đến CloudWatch
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
      minimum_scaling_step_size = 1  # Mỗi lần tăng/giảm tối thiểu bao nhiêu máy chủ
      maximum_scaling_step_size = 10 # Mỗi lần tăng/giảm tối đa bao nhiêu máy chủ
      status                    = var.managed_scaling_status
      target_capacity           = var.target_capacity
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

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name              = "/ecs/${var.task_family}"
  retention_in_days = 7

  tags = local.merged_tags
}

resource "aws_ecs_task_definition" "this" {
  family = var.task_family
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  network_mode             = var.task_network_mode
  requires_compatibilities = ["EC2"] # Launch type
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name              = var.container_name
      image             = var.container_image
      cpu               = var.task_cpu
      memory            = var.task_memory
      memoryReservation = var.task_memory_reservation
      essential         = true # Nếu container này sập thì toàn bộ Task sẽ được khởi động lại
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_task_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = local.merged_tags
}

resource "aws_ecs_service" "this" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.ecs_service_desired_count

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 100
    base              = 1
  }

  network_configuration {
    subnets         = var.ecs_service_subnets
    security_groups = var.ecs_service_security_groups
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = local.merged_tags
}
