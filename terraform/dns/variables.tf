variable "dns_global_forward_server" {}
variable "dns_hscn_forward_server_1" {}
variable "dns_hscn_forward_server_2" {}
variable "ecr_address" {}
variable "unbound_image_version" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "allowed_cidr" {}
variable "ssh_keypair_name" {}
variable "environment" {}
variable "mock_input" {}
variable "repo_name" {
  type = string
  default = "prm-mhs-infra"
}