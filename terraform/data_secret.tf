data "aws_ssm_parameter" "party-key" {
  name = "/repo/${var.environment}/${var.repo_name}/user-input/mhs-party-key"
}

data "aws_ssm_parameter" "client-cert" {
  name = "/repo/${var.environment}/${var.repo_name}/user-input/mhs-client-cert"
}

data "aws_ssm_parameter" "client-key" {
  name = "/repo/${var.environment}/${var.repo_name}/user-input/mhs-client-key"
}

data "aws_ssm_parameter" "ca-certs" {
  name = "/repo/${var.environment}/${var.repo_name}/user-input/mhs-ca-certs"
}
