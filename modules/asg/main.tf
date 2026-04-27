locals {
  default_tags = {
    Name      = "${var.project_name}-asg"
    ManagedBy = "Terraform"
  }

  merged_tags = merge(local.default_tags, var.tags)
}

# 1. Security Group cho ASG
resource "aws_security_group" "asg" {
  name_prefix = "${var.project_name}-asg-sg"
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.app_cidr_blocks
    content {
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-asg-sg"
  }
}

# 2. Launch Template
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data = base64encode(templatefile("${path.module}/scripts/install_web.sh", {
    project_name = var.project_name
  }))
  vpc_security_group_ids = [aws_security_group.asg.id]

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_name == null ? [] : [var.iam_instance_profile_name]
    content {
      name = iam_instance_profile.value
    }
  }

  block_device_mappings {
    device_name = var.ebs_device_name

    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = var.ebs_volume_type
      delete_on_termination = var.ebs_delete_on_termination
      encrypted             = var.ebs_encrypted
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.merged_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.merged_tags
  }

  tags = local.merged_tags
}

# 3. Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.project_name}-asg-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  dynamic "tag" {
    for_each = local.merged_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
