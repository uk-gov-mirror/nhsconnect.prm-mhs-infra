variable "build_id" {}
variable "region" {
  default = "eu-west-2"
}
variable "repo_name" {}
variable "environment" {}
variable "cluster_name" {}
variable "mhs_state_table_read_capacity" {}
variable "mhs_state_table_write_capacity" {}
variable "mhs_sync_async_table_read_capacity" {}
variable "mhs_sync_async_table_write_capacity" {}
