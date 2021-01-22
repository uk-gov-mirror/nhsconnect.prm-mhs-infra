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

variable "elasticache_node_type" {
  description = "The type of ElastiCache node to use when deploying the ElastiCache cluster. Possible node types can be found from https://aws.amazon.com/elasticache/features/#Available_Cache_Node_Types"
}

variable "spineroutelookup_service_sds_url" {
  description = "The SDS URL the Spine Route Lookup service should communicate with."
}

variable "spineroutelookup_service_search_base" {
  description = "The LDAP location the Spine Route Lookup service should use as the base of its searches when querying SDS."
}

variable "spineroutelookup_service_disable_sds_tls" {
  description = "Whether TLS should be disabled for connections to SDS."
  default = "False"
}

variable "mhs_log_level" {}

variable "build_id" {
  description = "ID used to identify the current build such as a commit sha."
}
