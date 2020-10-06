locals {
  subnet_ids = aws_subnet.mhs_subnet.*.id
  subnet_cidrs = aws_subnet.mhs_subnet.*.cidr_block
}

# Create a private subnet in each availability zone in the region.
resource "aws_subnet" "mhs_subnet" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id = local.mhs_vpc_id
  availability_zone = data.aws_availability_zones.all.names[count.index]

  # Generates a CIDR block with a different prefix within the VPC's CIDR block for each subnet being created.
  # E.g if the VPC's CIDR block is 10.0.0.0/16, this generates subnets that have CIDR blocks 10.0.0.0/24, 10.0.1.0/24,
  # etc.
  # see https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
  cidr_block = cidrsubnet(local.mhs_vpc_cidr_block, var.cidr_newbits, count.index)

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-mhs-subnet-${data.aws_availability_zones.all.names[count.index]}"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.use_existing_vpc == "" ? 0 : 1

  vpc_id = local.mhs_vpc_id
  availability_zone = data.aws_availability_zones.all.names[0]

  # Generates a CIDR block with a different prefix within the VPC's CIDR block for each subnet being created.
  # E.g if the VPC's CIDR block is 10.0.0.0/16, this generates subnets that have CIDR blocks 10.0.0.0/24, 10.0.1.0/24,
  # etc.
  # see https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
  cidr_block = cidrsubnet(local.mhs_vpc_cidr_block, var.cidr_newbits, length(data.aws_availability_zones.all.names))

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-mhs-public-subnet-${data.aws_availability_zones.all.names[0]}"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

