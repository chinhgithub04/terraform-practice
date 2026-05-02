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

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_port              = var.alb_port
  alb_protocol          = var.alb_protocol
  alb_cidr_blocks       = var.alb_cidr_blocks
  target_group_port     = var.target_group_port
  target_group_protocol = var.target_group_protocol
  tags                  = var.tags
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
  target_group_arns         = [module.alb.alb_target_group_arn]
  app_port                  = var.app_port
  app_cidr_blocks           = var.app_cidr_blocks
  iam_instance_profile_name = module.iam.app_server_iam_instance_profile_name
  tags                      = var.tags
}

module "rds" {
  source = "./modules/rds"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  rds_subnet_ids        = module.vpc.rds_subnet_ids
  app_security_group_id = module.asg.instance_security_group_id
  db_allocated_storage  = var.db_allocated_storage
  db_storage_type       = var.db_storage_type
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_port               = var.db_port
  tags                  = var.tags
}
