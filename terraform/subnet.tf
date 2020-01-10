locals {
  subnet_ids = var.use_existing_vpc == "" ? aws_subnet.mhs_subnet.*.id : data.aws_subnet.mhs_subnet.*.id
  subnet_cidrs = var.use_existing_vpc == "" ? aws_subnet.mhs_subnet.*.cidr_block : data.aws_subnet.mhs_subnet.*.cidr_block
}

# Create a private subnet in each availability zone in the region.
resource "aws_subnet" "mhs_subnet" {
  count = var.use_existing_vpc == "" ? length(data.aws_availability_zones.all.names) : 0

  vpc_id = local.mhs_vpc_id
  availability_zone = data.aws_availability_zones.all.names[count.index]

  # Generates a CIDR block with a different prefix within the VPC's CIDR block for each subnet being created.
  # E.g if the VPC's CIDR block is 10.0.0.0/16, this generates subnets that have CIDR blocks 10.0.0.0/24, 10.0.1.0/24,
  # etc.
  # see https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
  cidr_block = cidrsubnet(local.mhs_vpc_cidr_block, var.cidr_newbits, count.index)

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment_id}-mhs-subnet-${data.aws_availability_zones.all.names[count.index]}"
    EnvironmentId = var.environment_id
  }
}

data "aws_subnet" "mhs_subnet" {
  count = var.use_existing_vpc == "" ? 0 : length(data.aws_availability_zones.all.names)
  vpc_id = local.mhs_vpc_id
  cidr_block = cidrsubnet(local.mhs_vpc_cidr_block, var.cidr_newbits, count.index)
}
