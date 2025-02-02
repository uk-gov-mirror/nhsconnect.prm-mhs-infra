environment = "test"
cluster_name = "repo"
repo_name = "prm-mhs-infra"
mhs_state_table_read_capacity = 5
mhs_state_table_write_capacity = 5
mhs_sync_async_table_read_capacity = 5
mhs_sync_async_table_write_capacity = 5
elasticache_node_type               = "cache.t3.micro"
setup_public_dns_record = "true"
mhs_inbound_service_minimum_instance_count = 1
recipient_ods_code                  = "B86041" # Not enforced in opentest

spine_cidr = "0.0.0.0/0" # FIXME: narrow down to only the services that we talk to
sds_port                            = 636
spineroutelookup_service_sds_url    = "ldaps://ldap.nis1.national.ncrs.nhs.uk:636" # MUST BE AN IP in dev environment
mhs_forward_reliable_endpoint_url  = "https://msg.int.spine2.ncrs.nhs.uk/reliablemessaging/reliablerequest"
spineroutelookup_service_search_base = "ou=services,o=nhs"
spineroutelookup_service_disable_sds_tls = "False"
mhs_log_level                       = "DEBUG"
mhs_route_service_maximum_instance_count = 2
mhs_route_service_minimum_instance_count = 1
mhs_outbound_service_maximum_instance_count = 2
mhs_outbound_service_minimum_instance_count = 1
mhs_resynchroniser_max_retries="20"
mhs_resynchroniser_interval="1"
