data "aws_secretsmanager_secret" "party-key" {
  name = "/nhs/${var.deductions_env}/mhs/party-key"
}

data "aws_secretsmanager_secret" "client-cert" {
  name = "/nhs/${var.deductions_env}/mhs/client-cert"
}

data "aws_secretsmanager_secret" "client-key" {
  name = "/nhs/${var.deductions_env}/mhs/client-key"
}

data "aws_secretsmanager_secret" "ca-certs" {
  name = "/nhs/${var.deductions_env}/mhs/ca-certs"
}
