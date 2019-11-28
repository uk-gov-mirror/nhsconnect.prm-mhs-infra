
data "aws_caller_identity" "current" {}

# Get the list of availability zones for the selected AWS region
data "aws_availability_zones" "all" {}

data "aws_ssm_parameter" "spine_org_code" {
  name = "/NHS/deductions-${local.account_id}/opentest/spine_org_code"
}

data "aws_vpc" "supplier_vpc" {
  id = var.supplier_vpc_id
}
