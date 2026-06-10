locals {
  name_tag = {
    Name = "${var.project_name}-asg"
  }

  merged_tags = merge(local.name_tag, var.tags)
}

# 1. Security Group cho ASG
resource "aws_security_group" "asg" {
  name_prefix = "${var.project_name}-asg-sg"
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.ingress_rules) > 0 ? var.ingress_rules : [
      {
        from_port       = 8080
        to_port         = 8080
        protocol        = "tcp"
        cidr_blocks     = []
        security_groups = [var.alb_security_group_id]
        description     = "Allow traffic from ALB on port 8080"
      }
    ]
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
      description     = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      security_groups = egress.value.security_groups
      description     = egress.value.description
    }
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
  user_data     = var.user_data_base64 != null ? var.user_data_base64 : base64encode(templatefile("${path.module}/scripts/install_web.sh", {
    ecs_cluster_name = var.ecs_cluster_name
  }))
  vpc_security_group_ids = [aws_security_group.asg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.app_server_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
      encrypted             = true
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
  protect_from_scale_in     = var.protect_from_scale_in

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

# ==========================================
# IAM Role và Instance Profile tự đóng gói cho ASG
# ==========================================

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_server_role" {
  name               = "${var.project_name}-app-server-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-app-server-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  role       = aws_iam_role.app_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.app_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = toset(var.additional_iam_policies)
  role       = aws_iam_role.app_server_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "app_server_profile" {
  name = "${var.project_name}-app-server-instance-profile"
  role = aws_iam_role.app_server_role.name
}
