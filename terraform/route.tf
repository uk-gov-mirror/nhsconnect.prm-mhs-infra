resource "aws_route_table" "public" {
  count = var.use_existing_vpc == "" ? 0 : 1
  vpc_id = local.mhs_vpc_id

  tags = {
    Name = "mhs-ptl-public-subnet-rtb"
    CreatedBy = var.repo_name
  }
}

resource "aws_route_table_association" "public" {
  count = var.use_existing_vpc == "" ? 0 : 1
  subnet_id      = local.public_subnet_id
  route_table_id = local.public_subnet_route_table
}