data "aws_ssm_parameter" "party-key" {
  name = "/nhs/${var.environment_id}/mhs/party-key"
}

data "aws_ssm_parameter" "client-cert" {
  name = "/nhs/${var.environment_id}/mhs/client-cert"
}

data "aws_ssm_parameter" "client-key" {
  name = "/nhs/${var.environment_id}/mhs/client-key"
}

data "aws_ssm_parameter" "ca-certs" {
  name = "/nhs/${var.environment_id}/mhs/ca-certs"
}
