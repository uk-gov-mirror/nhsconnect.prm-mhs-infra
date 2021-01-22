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

data "aws_ssm_parameter" "dns_ip_address_0" {
    name = "/repo/${var.environment}/output/prm-deductions-infra/${var.cluster_name}-dns-ip-0"
}

data "aws_ssm_parameter" "dns_ip_address_1" {
    name = "/repo/${var.environment}/output/prm-deductions-infra/${var.cluster_name}-dns-ip-1"
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "party-key" {
  name = "/repo/${var.environment}/user-input/mhs-party-key"
}

data "aws_ssm_parameter" "client-cert" {
  name = "/repo/${var.environment}/user-input/mhs-client-cert"
}

data "aws_ssm_parameter" "client-key" {
  name = "/repo/${var.environment}/user-input/mhs-client-key"
}

data "aws_ssm_parameter" "ca-certs" {
  name = "/repo/${var.environment}/user-input/mhs-ca-certs"
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  ecr_address = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com" # created in prm-deductions-base-infra

  mhs_vpc_id = data.aws_vpc.mhs.id
  mhs_private_subnet_ids = data.aws_subnet_ids.mhs_private.*.id
  dns_ip_address_0 = data.aws_ssm_parameter.dns_ip_address_0
  dns_ip_address_1 = data.aws_ssm_parameter.dns_ip_address_1

  # MHS secrets to connect with spine
  party_key_arn=data.aws_ssm_parameter.party-key.arn
  client_cert_arn=data.aws_ssm_parameter.client-cert.arn
  client_key_arn=data.aws_ssm_parameter.client-key.arn
  ca_certs_arn=data.aws_ssm_parameter.ca-certs.arn
}
