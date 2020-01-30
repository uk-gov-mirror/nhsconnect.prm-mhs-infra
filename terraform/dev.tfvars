region                              = "eu-west-2"
environment_id                      = "dev" # just a name identifier
recipient_ods_code                  = "opentest" # Not used in opentest
nlb_deletion_protection             = false
mhs_vpc_cidr_block                  = "10.33.0.0/16" # Must not conflict with other networks
internal_root_domain                = "mhs.patient-deductions.nhs.uk" # DNS zone inside MHS VPC
mhs_inbound_service_maximum_instance_count = 2
mhs_inbound_service_minimum_instance_count = 1
mhs_outbound_service_maximum_instance_count = 2
mhs_outbound_service_minimum_instance_count = 1
mhs_route_service_maximum_instance_count = 2
mhs_route_service_minimum_instance_count = 1
mhs_log_level                       = "DEBUG"
elasticache_node_type               = "cache.t3.micro"
supplier_vpc_id                     = "vpc-0918f832cc6eb6370" # That should be deductions-private. TODO: from SSM

# From https://gpitbjss.atlassian.net/wiki/spaces/RTDel/pages/1606615966/Deploying+the+Exemplar+Architecture
mhs_resynchroniser_max_retries="20"
mhs_resynchroniser_interval="1"
mhs_state_table_read_capacity=5
mhs_state_table_write_capacity=5
mhs_sync_async_table_read_capacity=5
mhs_sync_async_table_write_capacity=5

# Issued with a private CA
outbound_alb_certificate_arn="arn:aws:acm:eu-west-2:327778747031:certificate/67279db0-17f9-4517-8572-eb739ae6808b"
route_alb_certificate_arn="arn:aws:acm:eu-west-2:327778747031:certificate/3630471e-0ca2-4aec-a7f1-ef78258c8283"

use_opentest="true"
mhs_forward_reliable_endpoint_url  = "https://192.168.128.11/reliablemessaging/forwardreliable" # specific to opentest
# have a look at curl to PDS, SDS in dev-network from a bastion
# The SDS URL the Spine Route Lookup service should communicate with.
# The LDAP location the Spine Route Lookup service should use as the base of its searches when querying SDS.

spineroutelookup_service_sds_url    = "ldap://192.168.128.11:389" # It seems so based on code usage, search for SDS_URL. MUST BE AN IP!!
spineroutelookup_service_search_base = "ou=services,o=nhs"
spineroutelookup_service_disable_sds_tls = "True" # Makes sense for opentest
