terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Cấu hình backend để lưu trạng thái Terraform trên S3
  backend "s3" {
    bucket         = "xbrain-terraform-s3-tfstate"
    key            = "dev/xbrain-vpc.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "xbrain-dynamodb-terraform"
  }
}

provider "aws" {
  region = "us-east-1"
}
