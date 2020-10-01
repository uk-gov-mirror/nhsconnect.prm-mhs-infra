# These resources are only needed to deploy GoCD in the MHS network

module "gocd" {
    source = "git::https://github.com/nhsconnect/prm-gocd-infra.git//remote-agents-module"
    environment = "prod"
    region = "${var.region}"
    az = data.aws_availability_zones.all.names[0]
    vpc_id = local.mhs_vpc_id
    subnet_id = local.public_subnet_id
    agent_resources = "${var.environment},mhs"
    allocate_public_ip = true
    agent_count = 1
}

data "aws_ssm_parameter" "gocd_vpc" {
  name = "/repo/prod/prm-gocd-infra/output/gocd-vpc-id"
}

data "aws_ssm_parameter" "gocd_zone_id" {
  name = "/repo/prod/prm-gocd-infra/output/gocd-route53-zone-id"
}

data "aws_ssm_parameter" "gocd_cidr_block" {
  name = "/repo/prod/prm-gocd-infra/output/gocd-cidr-block"
}

data "aws_ssm_parameter" "route_table_id" {
  name = "/repo/prod/prm-gocd-infra/output/gocd-route-table-id"
}

locals {
  gocd_vpc = data.aws_ssm_parameter.gocd_vpc.value
  gocd_zone_id = data.aws_ssm_parameter.gocd_zone_id.value
  gocd_cidr_block = data.aws_ssm_parameter.gocd_cidr_block.value
}

# VPC peering connection with GoCD server
resource "aws_vpc_peering_connection" "gocd_peering_connection" {
  peer_vpc_id = local.gocd_vpc
  vpc_id = local.mhs_vpc_id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "${var.environment}-mhs-gocd-peering-connection"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

# Add a route to the MHS VPC in the gocd VPC route table
resource "aws_route" "gocd_to_mhs_route" {
  route_table_id = data.aws_ssm_parameter.route_table_id.value
  destination_cidr_block = local.mhs_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.gocd_peering_connection.id
}

# Add a route to the gocd VPC in the MHS VPC route table
resource "aws_route" "mhs_to_gocd_route" {
  route_table_id = local.public_subnet_route_table
  destination_cidr_block = local.gocd_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.gocd_peering_connection.id
}

# Allow DNS resolution of the domain names defined in gocd VPC in mhs vpc
resource "aws_route53_zone_association" "mhs_hosted_zone_gocd_vpc_association" {
  zone_id = local.gocd_zone_id
  vpc_id = local.mhs_vpc_id
}
