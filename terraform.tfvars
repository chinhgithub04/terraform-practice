# Global
aws_region         = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]
project_name       = "xbrain-project"

# VPC
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

# ASG
ami_id                    = "ami-098e39bafa7e7303d"
instance_type             = "t3.micro"
ebs_device_name           = "/dev/xvda"
ebs_volume_size           = 8
ebs_volume_type           = "gp3"
ebs_delete_on_termination = true
ebs_encrypted             = true
min_size                  = 1
max_size                  = 3
desired_capacity          = 2
health_check_type         = "ELB"
health_check_grace_period = 300
app_port                  = 8080
app_cidr_blocks           = ["0.0.0.0/0"]

# ALB
alb_port              = 80
alb_protocol          = "HTTP"
alb_cidr_blocks       = ["0.0.0.0/0"]
target_group_port     = 8080
target_group_protocol = "HTTP"

# RDS
db_storage_type      = "gp3"
db_allocated_storage = 20
db_engine            = "mysql"
db_engine_version    = "8.0.45"
db_instance_class    = "db.t3.micro"
db_name              = "merxly"
db_username          = "admin"
db_port              = 3306

tags = {
  Environment = "dev"
  Owner       = "xbrain"
}
