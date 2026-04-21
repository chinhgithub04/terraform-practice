resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name      = "${var.project_name}-vpc"
    ManagedBy = "Terraform"
  }
}
