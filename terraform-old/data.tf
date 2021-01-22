
data "aws_caller_identity" "current" {}

# Get the list of availability zones for the selected AWS region
data "aws_availability_zones" "all" {}

data "aws_ssm_parameter" "spine_org_code" {
  name = "/repo/dev/user-input/opentest-spine-org-code"
}

//data "aws_vpc" "supplier_vpc" {
//  id = data.aws_ssm_parameter.deductions-private-vpc.value
//}

//data "aws_ssm_parameter" "deductions-private-vpc" {
//  name = "/repo/${var.environment}/output/prm-deductions-infra/private-vpc-id"
//}

data "aws_ssm_parameter" "mq-app-username" {
  name = "/repo/${var.environment}/user-input/mq-app-username"
}

data "aws_ssm_parameter" "mq-app-password" {
  name = "/repo/${var.environment}/user-input/mq-app-password"
}

data "aws_ssm_parameter" "amqp-endpoint-0" {
  name = "/repo/${var.environment}/output/prm-deductions-infra/amqp-endpoint-0"
}

data "aws_ssm_parameter" "amqp-endpoint-1" {
  name = "/repo/${var.environment}/output/prm-deductions-infra/amqp-endpoint-1"
}

data "aws_ssm_parameter" "amqp-endpoint-active" {
  name = "/repo/${var.environment}/output/prm-deductions-infra/amqp-endpoint-active"
}
