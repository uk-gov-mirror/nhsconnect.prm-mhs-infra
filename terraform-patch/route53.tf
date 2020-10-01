data "aws_ssm_parameter" "root_zone_id" {
  name = "/repo/prm-deductions-base-infra/output/root-zone-id"
}

data "aws_ssm_parameter" "route_dns_name" {
  name = "/repo/${var.environment}/${var.repo_name}/output/mhs-route-dns-name"
}

# Public DNS record for the MHS inbound component
resource "aws_route53_record" "mhs_inbound_load_balancer_record" {
  zone_id = data.aws_ssm_parameter.root_zone_id.value
  name = data.aws_ssm_parameter.route_dns_name.value
  type = "A"
  ttl = 600

  records = local.aws_nlb_network_interface_ips
}
