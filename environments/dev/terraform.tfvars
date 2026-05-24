# Global
aws_region         = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]
project_name       = "xbrain-dev"

# VPC
vpc_cidr = "10.0.0.0/16"
public_subnets = {
  "public-alb-1a" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    type              = "alb"
  }
  "public-alb-1b" = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    type              = "alb"
  }
  "public-nat-1a" = {
    cidr_block        = "10.0.10.0/26"
    availability_zone = "us-east-1a"
    type              = "nat"
  }
}
private_subnets = {
  "private-app-1a" = {
    cidr_block           = "10.0.3.0/24"
    availability_zone    = "us-east-1a"
    type                 = "app"
    nat_gateway_route_to = "public-nat-1a"
  }
  "private-app-1b" = {
    cidr_block           = "10.0.4.0/24"
    availability_zone    = "us-east-1b"
    type                 = "app"
    nat_gateway_route_to = "public-nat-1a"
  }
  "private-db-1a" = {
    cidr_block           = "10.0.5.0/24"
    availability_zone    = "us-east-1a"
    type                 = "db"
    nat_gateway_route_to = "public-nat-1a"
  }
  "private-db-1b" = {
    cidr_block           = "10.0.6.0/24"
    availability_zone    = "us-east-1b"
    type                 = "db"
    nat_gateway_route_to = "public-nat-1a"
  }
}

# EC2 / ASG
ami_id           = "ami-098e39bafa7e7303d"
instance_type    = "t3.micro"
min_size         = 1
max_size         = 1
desired_capacity = 1

# RDS
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name              = "merxly_dev"

# ECR
ecr_repository_name = "xbrain-app-repo-dev"

# ECS
ecs_cluster_name            = "xbrain-ecs-cluster-dev"
ecs_task_family             = "xbrain-app-task-dev"
ecs_container_name          = "xbrain-app-container-dev"
ecs_service_name            = "xbrain-app-service-dev"
ecs_service_desired_count   = 2
ecs_task_cpu                = 512
ecs_task_memory             = 1024
ecs_task_memory_reservation = 1024

tags = {
  Environment = "dev"
  Owner       = "xbrain"
}
