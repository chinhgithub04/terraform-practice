# Global
aws_region         = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]
project_name       = "xbrain-prod"

# VPC (Non-overlapping CIDR block for production environment)
vpc_cidr = "10.1.0.0/16"
public_subnets = {
  "public-1a" = {
    cidr_block        = "10.1.1.0/24"
    availability_zone = "us-east-1a"
  }
  "public-1b" = {
    cidr_block        = "10.1.2.0/24"
    availability_zone = "us-east-1b"
  }
}
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

# EC2 / ASG (High availability and larger scale for production)
ami_id           = "ami-098e39bafa7e7303d"
instance_type    = "t3.small"
min_size         = 1
max_size         = 2
desired_capacity = 2

# RDS (Higher storage and performance for production)
db_instance_class    = "db.t3.small"
db_allocated_storage = 100
db_name              = "merxly_prod"

# ECR
ecr_repository_name = "xbrain-app-repo-prod"

# ECS (More tasks and higher CPU/Memory allocation for production tasks)
ecs_cluster_name            = "xbrain-ecs-cluster-prod"
ecs_task_family             = "xbrain-app-task-prod"
ecs_container_name          = "xbrain-app-container-prod"
ecs_service_name            = "xbrain-app-service-prod"
ecs_service_desired_count   = 3
ecs_task_cpu                = 1024
ecs_task_memory             = 2048
ecs_task_memory_reservation = 2048

tags = {
  Environment = "production"
  Owner       = "xbrain-prod"
}
