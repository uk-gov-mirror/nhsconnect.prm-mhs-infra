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
  name = "/repo/${var.environment}/prm-mhs-infra/output/mhs-outbound-url"
  type  = "String"
  value = trimsuffix("https://${aws_route53_record.mhs_outbound_load_balancer_record.name}", ".")
}

resource "aws_ssm_parameter" "inbound_url" {
  name = "/repo/${var.environment}/prm-mhs-infra/output/mhs-inbound-url"
  type  = "String"
  value = trimsuffix("${aws_route53_record.mhs_inbound_load_balancer_record.name}", ".")
}

resource "aws_ssm_parameter" "route_url" {
  name = "/repo/${var.environment}/prm-mhs-infra/output/mhs-route-url"
  type  = "String"
  value = trimsuffix("https://${aws_route53_record.mhs_route_load_balancer_record.name}", ".")
}

resource "aws_ssm_parameter" "mhs_vpc" {
  name = "/repo/${var.environment}/prm-mhs-infra/output/mhs-vpc-id"
  type  = "String"
  value = local.mhs_vpc_id
}

resource "aws_ssm_parameter" "dns_servers" {
  name = "/repo/${var.environment}/prm-mhs-infra/output/mhs-dns-servers"
  type  = "String"
  value = join(",", module.dns.dns_ip_addresses)
}
