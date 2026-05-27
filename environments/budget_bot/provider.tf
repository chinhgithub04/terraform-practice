terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "W7Capstone"
      Team        = "G9"
      Owner       = "G9"
      Environment = "hackathon"
    }
  }
}
