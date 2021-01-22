environment = "dev"
cluster_name = "repo"
mhs_state_table_read_capacity = 5
mhs_state_table_write_capacity = 5
repo_name = "prm-mhs-infra"
mhs_sync_async_table_read_capacity = 5
mhs_sync_async_table_write_capacity = 5
elasticache_node_type               = "cache.t3.micro"

spineroutelookup_service_sds_url    = "ldap://192.168.128.11:389" # MUST BE AN IP in dev environment
spineroutelookup_service_search_base = "ou=services,o=nhs"
spineroutelookup_service_disable_sds_tls = "True"
mhs_log_level                       = "DEBUG"
