# Workaround https://github.com/terraform-providers/terraform-provider-aws/pull/2901
# There is no way to obtain private IPs of an internal NLB
# All these IPs need to be resolvable on the HSCN network, so that spine can send messages to it

variable "environment" {}

locals {
  alb_nlb_name = "${var.environment}-mhs-inbound-nlb"
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "mhs_vpc" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/mhs-${var.environment}/vpc_id"
}

data "aws_network_interfaces" "this" {
  filter {
    name = "description"
    values = ["ELB net/${local.alb_nlb_name}/*"]
  }
  filter {
    name = "vpc-id"
    values = [data.aws_ssm_parameter.mhs_vpc.value]
  }
  filter {
    name = "status"
    values = ["in-use"]
  }
  filter {
    name = "attachment.status"
    values = ["attached"]
  }
}

locals {
  nlb_network_interface_ids = "${flatten(["${data.aws_network_interfaces.this.ids}"])}"
}

data "aws_network_interface" "ifs" {
  count = "${length(local.nlb_network_interface_ids)}"
  id = "${local.nlb_network_interface_ids[count.index]}"
}

locals {
  aws_nlb_network_interface_ips = "${flatten([data.aws_network_interface.ifs.*.private_ips])}"
  aws_nlb_network_interface_cidr_blocks = [ for ip in local.aws_nlb_network_interface_ips : "${ip}/32" ]
}

output "nlb_ips" {
  value = local.aws_nlb_network_interface_ips
}
