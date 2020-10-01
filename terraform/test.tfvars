region                              = "eu-west-2"
repo_name                           = "prm-mhs-infra"
environment                         = "test" # just a name identifier
recipient_ods_code                  = "B86041"
nlb_deletion_protection             = true
mhs_vpc_cidr_block                  = "10.34.0.0/16" # Must not conflict with other networks
internal_root_domain                = "mhs.patient-deductions.nhs.uk" # DNS zone inside MHS VPC
mhs_inbound_service_maximum_instance_count = 2
mhs_inbound_service_minimum_instance_count = 1
mhs_outbound_service_maximum_instance_count = 2
mhs_outbound_service_minimum_instance_count = 1
mhs_route_service_maximum_instance_count = 2
mhs_route_service_minimum_instance_count = 1
mhs_log_level                       = "DEBUG"
elasticache_node_type               = "cache.t3.micro"
supplier_vpc_id                     = "vpc-085feb2f69e5afdac" # That should be deductions-private. TODO: from SSM

# From https://gpitbjss.atlassian.net/wiki/spaces/RTDel/pages/1606615966/Deploying+the+Exemplar+Architecture
mhs_resynchroniser_max_retries="20"
mhs_resynchroniser_interval="1"
mhs_state_table_read_capacity=5
mhs_state_table_write_capacity=5
mhs_sync_async_table_read_capacity=5
mhs_sync_async_table_write_capacity=5

use_existing_vpc="vpc-0a7a8d6e6ffcd4854" # prm-dev-dxnetwork: 10.239.68.128/25
cidr_newbits=2
use_opentest="false"
# Issued with a private CA. It's OK, because these are consumed only by our (deductions) side.
# Spine is accessing only the inbound component which is signed by NHS'es root CA.
outbound_alb_certificate_arn="arn:aws:acm:eu-west-2:327778747031:certificate/4289f294-49b4-4949-84ca-11cda3e84a59"
route_alb_certificate_arn="arn:aws:acm:eu-west-2:327778747031:certificate/5eed36c1-6aba-4909-be94-b50019bb57b0"

 # FIXME: Unsure if this is correct, see https://digital.nhs.uk/services/path-to-live-environments/integration-environment#messaging-urls
mhs_forward_reliable_endpoint_url  = "https://msg.int.spine2.ncrs.nhs.uk/reliablemessaging/reliablerequest"
# have a look at curl to PDS, SDS in dev-network from a bastion
# The SDS URL the Spine Route Lookup service should communicate with.
# The LDAP location the Spine Route Lookup service should use as the base of its searches when querying SDS.

# There is only one ldaps service on
# https://digital.nhs.uk/services/path-to-live-environments/integration-environment#system-urls
# It seems so based on usage in code, search for SDS_URL.
# Opentest experiments showed that this MUST BE AN IP!!
spineroutelookup_service_sds_url    = "ldaps://10.196.94.141:636"
spineroutelookup_service_search_base = "ou=services,o=nhs"
spineroutelookup_service_disable_sds_tls = "False" # Must be false in PTL due to ldaps usage (as opposed to ldap in opentest)

dns_hscn_forward_server_1 = "155.231.231.1"
dns_hscn_forward_server_2 = "155.231.231.2"
