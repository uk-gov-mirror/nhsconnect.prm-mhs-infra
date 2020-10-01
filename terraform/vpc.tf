locals {
  # join is to workaround terraform evaluating both branches regardless of the condition value
  mhs_vpc_id = join(",",
    var.use_existing_vpc == "" ?
       split(",", join(",", aws_vpc.mhs_vpc.*.id)) : [var.use_existing_vpc])
  mhs_vpc_cidr_block = join(",", var.use_existing_vpc == "" ?
    [var.mhs_vpc_cidr_block] : [join(",", data.aws_vpc.mhs_vpc.*.cidr_block)])
  mhs_vpc_route_table_id = join(",", var.use_existing_vpc == "" ?
     [join(",", aws_vpc.mhs_vpc.*.main_route_table_id)] : [join(",", data.aws_vpc.mhs_vpc.*.main_route_table_id)])
}

# The MHS VPC that contains the running MHS
resource "aws_vpc" "mhs_vpc" {
  count =  var.use_existing_vpc == "" ? 1 : 0
  # Note that this cidr block must not overlap with the cidr blocks of the VPCs
  # that the MHS VPC is peered with.
  cidr_block = var.mhs_vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-mhs-vpc"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

data "aws_vpc" "mhs_vpc" {
  count = var.use_existing_vpc == "" ? 0 : 1
  id = var.use_existing_vpc
}
