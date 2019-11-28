locals {
  account_id = data.aws_caller_identity.current.account_id
  mhs_spine_org_code   = data.aws_ssm_parameter.spine_org_code.value
  ecr_address = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com" # created in prm-deductions-base-infra

  #FIXME: read these from SSM
  inbound_queue_host="amqp+ssl://b-93946876-8604-4815-8ef3-eb4f1dc68c95-1.mq.eu-west-2.amazonaws.com:5671"
  inbound_queue_username_arn="arn:aws:secretsmanager:eu-west-2:${local.account_id}:secret:/nhs/dev/mq2/username-c29IDe"
  inbound_queue_password_arn="arn:aws:secretsmanager:eu-west-2:${local.account_id}:secret:/nhs/dev/mq2/password-VptMfq"

}
