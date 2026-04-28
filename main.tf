module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  aws_region           = var.aws_region
  availability_zones   = var.availability_zones
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "asg" {
  source = "./modules/asg"

  project_name              = var.project_name
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.app_subnet_ids
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  ebs_device_name           = var.ebs_device_name
  ebs_volume_size           = var.ebs_volume_size
  ebs_volume_type           = var.ebs_volume_type
  ebs_delete_on_termination = var.ebs_delete_on_termination
  ebs_encrypted             = var.ebs_encrypted
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = var.target_group_arns
  app_port                  = var.app_port
  app_cidr_blocks           = var.app_cidr_blocks
  iam_instance_profile_name = module.iam.app_server_iam_instance_profile_name
  tags                      = var.tags
}
