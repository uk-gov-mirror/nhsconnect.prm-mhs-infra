locals {
  account_id = data.aws_caller_identity.current.account_id
  mhs_spine_org_code   = data.aws_ssm_parameter.spine_org_code.value
  ecr_address = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com" # created in prm-deductions-base-infra

  inbound_queue_username_arn=data.aws_secretsmanager_secret.mq-app-username.arn
  inbound_queue_password_arn=data.aws_secretsmanager_secret.mq-app-password.arn
  #FIXME should use a failover connection string with both endpoints
  inbound_queue_host=replace(data.aws_ssm_parameter.amqp-endpoint-1.value, "amqp+ssl", "amqps")

  party_key_arn=data.aws_secretsmanager_secret.party-key.arn
  client_cert_arn=data.aws_secretsmanager_secret.client-cert.arn
  client_key_arn=data.aws_secretsmanager_secret.client-key.arn
  ca_certs_arn=data.aws_secretsmanager_secret.ca-certs.arn

  # IAM for ECS tasks:
  task_role_arn = aws_iam_role.mhs.arn
  task_scaling_role_arn = aws_iam_role.mhs-as.arn
  execution_role_arn = aws_iam_role.mhs-ecs.arn
}
