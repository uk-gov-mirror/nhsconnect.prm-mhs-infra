locals {
  # Workaround terraform: Cannot have conditional modules or count in module
  ptl_resource_count = var.use_opentest == "true" ? 0 : 1
}

##############
# PTL-integration connectivity
##############

# Allow outbound HTTP requests from MHS outbound security group to Spine in PTL
resource "aws_security_group_rule" "mhs_outbound_security_group_ptl_http_proxy_egress_rule" {
  security_group_id = aws_security_group.mhs_outbound_security_group.id
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [var.spine_cidr] #TODO: figure out small cidr 
  description = "Allow outbound requests to the HTTPS spine in PTL-Integration"
  count = local.ptl_resource_count
}

# Allow outbound LDAP requests from MHS route security group to Spine in PTL
resource "aws_security_group_rule" "mhs_route_security_group_ptl_ldap_proxy_egress_rule" {
  security_group_id = aws_security_group.mhs_route_security_group.id
  type = "egress"
  from_port = 636
  to_port = 636
  protocol = "tcp"
  cidr_blocks = [var.spine_cidr] # probably can be just 10.196.94.141/32
  description = "Allow outbound LDAPS requests to PDS in PTL-Integration"
  count = local.ptl_resource_count
}
