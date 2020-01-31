
data "aws_caller_identity" "current" {}

# Get the list of availability zones for the selected AWS region
data "aws_availability_zones" "all" {}

data "aws_ssm_parameter" "spine_org_code" {
  name = "/NHS/deductions-${local.account_id}/opentest/spine_org_code"
}

data "aws_vpc" "supplier_vpc" {
  id = var.supplier_vpc_id
}

data "aws_ssm_parameter" "mq-app-username" {
  name = "/nhs/${var.environment_id}/mq/app-username"
}

data "aws_ssm_parameter" "mq-app-password" {
  name = "/nhs/${var.environment_id}/mq/app-password"
}

data "aws_ssm_parameter" "amqp-endpoint-0" {
  name        = "/NHS/${var.environment_id}-${data.aws_caller_identity.current.account_id}/amqp-endpoint/0"
}

data "aws_ssm_parameter" "amqp-endpoint-1" {
  name        = "/NHS/${var.environment_id}-${data.aws_caller_identity.current.account_id}/amqp-endpoint/1"
}

data "aws_ssm_parameter" "amqp-endpoint-active" {
  name        = "/NHS/${var.environment_id}-${data.aws_caller_identity.current.account_id}/amqp-endpoint/active"
}
