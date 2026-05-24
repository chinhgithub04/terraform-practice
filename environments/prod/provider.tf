terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "xbrain-terraform-s3-tfstate"
    key          = "prod/xbrain-vpc.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.tags["Environment"]
      Owner       = var.tags["Owner"]
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
