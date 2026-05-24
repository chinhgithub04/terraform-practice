module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

module "alb" {
  source = "../../modules/alb"

  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  alb_subnet_ids = module.vpc.alb_subnet_ids
}

module "asg" {
  source = "../../modules/asg"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.alb_security_group_id
  ecs_cluster_name      = var.ecs_cluster_name
  private_subnet_ids    = module.vpc.app_subnet_ids
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  tags                  = var.tags
}

module "rds" {
  source = "../../modules/rds"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  rds_subnet_ids        = module.vpc.rds_subnet_ids
  app_security_group_id = module.asg.instance_security_group_id
  db_allocated_storage  = var.db_allocated_storage
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
}

module "ecr" {
  source = "../../modules/ecr"

  project_name        = var.project_name
  ecr_repository_name = var.ecr_repository_name
}

module "ecs" {
  source = "../../modules/ecs"

  project_name                = var.project_name
  ecs_cluster_name            = var.ecs_cluster_name
  asg_arn                     = module.asg.asg_arn
  task_family                 = var.ecs_task_family
  container_name              = var.ecs_container_name
  container_image             = module.ecr.ecr_repository_url
  task_cpu                    = var.ecs_task_cpu
  task_memory                 = var.ecs_task_memory
  task_memory_reservation     = var.ecs_task_memory_reservation
  ecs_service_name            = var.ecs_service_name
  ecs_service_desired_count   = var.ecs_service_desired_count
  target_group_arn            = module.alb.alb_target_group_arn
  ecs_service_subnets         = module.vpc.app_subnet_ids
  ecs_service_security_groups = [module.asg.instance_security_group_id]
}
