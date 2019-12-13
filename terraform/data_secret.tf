data "aws_secretsmanager_secret" "party-key" {
  name = "/nhs/${var.environment_id}/mhs/party-key"
}

data "aws_secretsmanager_secret" "client-cert" {
  name = "/nhs/${var.environment_id}/mhs/client-cert"
}

data "aws_secretsmanager_secret" "client-key" {
  name = "/nhs/${var.environment_id}/mhs/client-key"
}

data "aws_secretsmanager_secret" "ca-certs" {
  name = "/nhs/${var.environment_id}/mhs/ca-certs"
}
