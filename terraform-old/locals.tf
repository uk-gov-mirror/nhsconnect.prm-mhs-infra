locals {
  account_id = data.aws_caller_identity.current.account_id
  mhs_spine_org_code   = data.aws_ssm_parameter.spine_org_code.value
  ecr_address = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com" # created in prm-deductions-base-infra

  public_subnet_cidr = join(",", var.use_opentest == "true" ?
    [var.vpn_subnet] : [join(",", aws_subnet.public_subnet.*.cidr_block)])
  public_subnet_id = join(",", var.use_opentest == "true" ?
    [module.opentest.subnet_id] : [join(",", aws_subnet.public_subnet.*.id)])
  public_subnet_route_table = var.use_opentest == "true" ? module.opentest.public_route_table_id : join(",", aws_route_table.public.*.id)

  inbound_queue_username_arn=data.aws_ssm_parameter.mq-app-username.arn
  inbound_queue_password_arn=data.aws_ssm_parameter.mq-app-password.arn
  #FIXME should use a failover connection string with both endpoints
  inbound_queue_host=replace(data.aws_ssm_parameter.amqp-endpoint-active.value, "amqp+ssl", "amqps")

  # MHS secrets to connect with spine
  party_key_arn=data.aws_ssm_parameter.party-key.arn
  client_cert_arn=data.aws_ssm_parameter.client-cert.arn
  client_key_arn=data.aws_ssm_parameter.client-key.arn
  ca_certs_arn=data.aws_ssm_parameter.ca-certs.arn

  # IAM for ECS tasks:
  task_role_arn = aws_iam_role.mhs.arn
  task_scaling_role_arn = aws_iam_role.mhs-as.arn
  execution_role_arn = aws_iam_role.mhs-ecs.arn
}
