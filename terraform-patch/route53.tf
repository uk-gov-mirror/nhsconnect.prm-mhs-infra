data "aws_ssm_parameter" "root_zone_id" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/root_zone_id"
}

data "aws_ssm_parameter" "route_dns_name" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment}/route_dns_name"
}

# Public DNS record for the MHS inbound component
resource "aws_route53_record" "mhs_inbound_load_balancer_record" {
  zone_id = data.aws_ssm_parameter.root_zone_id.value
  name = data.aws_ssm_parameter.route_dns_name.value
  type = "A"
  ttl = 600

  records = local.aws_nlb_network_interface_ips
}
