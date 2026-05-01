locals {
  default_tags = {
    Name      = "${var.project_name}-asg"
    ManagedBy = "Terraform"
  }

  merged_tags = merge(local.default_tags, var.tags)
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_cidr_blocks
    content {
      from_port   = var.alb_port
      to_port     = var.alb_port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }

}

resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    protocol            = var.target_group_protocol
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name      = "${var.project_name}-alb"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.alb_port
  protocol            = var.alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
