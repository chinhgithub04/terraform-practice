resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights" # Gửi metrics và logs của ECS cluster đến CloudWatch
    value = "enabled"
  }

  tags = {
    Name = var.ecs_cluster_name
  }
}

resource "aws_ecs_capacity_provider" "this" {
  name = "${var.project_name}-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      minimum_scaling_step_size = 1  # Mỗi lần tăng/giảm tối thiểu bao nhiêu máy chủ
      maximum_scaling_step_size = 10 # Mỗi lần tăng/giảm tối đa bao nhiêu máy chủ
      status                    = "ENABLED"
      target_capacity           = 80
    }
  }

  tags = {
    Name = "${var.project_name}-ecs-capacity-provider"
  }
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

  tags = {
    Name = "${var.project_name}-ecs-task-logs"
  }
}

# ECS Task Execution Role & Task Role
data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = {
    Name = "${var.project_name}-ecs-task-execution-role"
  }
}

data "aws_iam_policy_document" "ecs_task_execution_custom_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [var.ecr_repository_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.ecs_task_logs.arn}:*"]
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_custom_policy" {
  name   = "${var.project_name}-ecs-task-execution-policy"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.ecs_task_execution_custom_policy.json
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = {
    Name = "${var.project_name}-ecs-task-role"
  }
}

resource "aws_ecs_task_definition" "this" {
  family = var.task_family
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"] # Launch type
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

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
          containerPort = 8080
          hostPort      = 8080
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

  tags = {
    Name = var.task_family
  }
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
    container_port   = 8080
  }

  propagate_tags          = "SERVICE"
  enable_ecs_managed_tags = true

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    Name = var.ecs_service_name
  }
}
