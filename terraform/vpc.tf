
# The MHS VPC that contains the running MHS
resource "aws_vpc" "mhs_vpc" {
  # Note that this cidr block must not overlap with the cidr blocks of the VPCs
  # that the MHS VPC is peered with.
  cidr_block = var.mhs_vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment_id}-mhs-vpc"
    EnvironmentId = var.environment_id
  }
}

resource "aws_ssm_parameter" "mhs_vpc" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment_id}/vpc_id"
  type  = "String"
  value = aws_vpc.mhs_vpc.id
}
