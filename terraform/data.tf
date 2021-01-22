# Discover the VPC and private subnets to deploy MHS in.
data "aws_vpc" "mhs" {
  filter {
    name = "tag:Name"
    values = ["${var.environment}-${var.cluster_name}-mhs-vpc"]
  }
}

data "aws_subnet_ids" "mhs_private" {
  vpc_id = local.mhs_vpc_id
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.cluster_name}-mhs-private-subnet-*"]
  }
}

locals {
  mhs_vpc_id = data.aws_vpc.mhs.id
  mhs_private_subnet_ids = data.aws_subnet_ids.mhs_private.*.id
}
