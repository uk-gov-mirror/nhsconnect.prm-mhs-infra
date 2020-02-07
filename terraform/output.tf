output "outbound_url" {
  value = aws_ssm_parameter.outbound_url.value
}

output "inbound_url" {
  value = aws_ssm_parameter.inbound_url.value
}

output "route_url" {
  value = aws_ssm_parameter.route_url.value
}

output "dns_servers" {
  value = module.dns.dns_ip_addresses
}

variable "deductions_env" {
  default = "dev" #FIXME: just use same env name, requires new certs
}

resource "aws_ssm_parameter" "outbound_url" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment_id}/outbound_url"
  type  = "String"
  value = trimsuffix("https://${aws_route53_record.mhs_outbound_load_balancer_record.name}", ".")
}

resource "aws_ssm_parameter" "inbound_url" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment_id}/inbound_url"
  type  = "String"
  value = trimsuffix("${aws_route53_record.mhs_inbound_load_balancer_record.name}", ".")
}

resource "aws_ssm_parameter" "route_url" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment_id}/route_url"
  type  = "String"
  value = trimsuffix("https://${aws_route53_record.mhs_route_load_balancer_record.name}", ".")
}

resource "aws_ssm_parameter" "mhs_vpc" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment_id}/vpc_id"
  type  = "String"
  value = local.mhs_vpc_id
}

resource "aws_ssm_parameter" "dns_servers" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment_id}/dns_servers"
  type  = "String"
  value = join(",", module.dns.dns_ip_addresses)
}
