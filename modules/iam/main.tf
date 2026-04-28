# 1. App server role và instance profile
## Policy assume role cho EC2
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

## IAM Role cho app server
resource "aws_iam_role" "app_server_role" {
  name               = "${var.project_name}-app-server-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-app-server-role"
  }
}

## Gắn policy quản lý SSM vào role
resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  role       = aws_iam_role.app_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## Instance Profile dành cho EC2
resource "aws_iam_instance_profile" "app_server_profile" {
  name = "${var.project_name}-app-server-instance-profile"
  role = aws_iam_role.app_server_role.name
}
