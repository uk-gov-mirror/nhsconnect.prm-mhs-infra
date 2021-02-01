cluster_name = "repo"
cluster_domain_name = "mhs.patient-deductions.nhs.uk"
route_alb_certificate_arn="arn:aws:acm:eu-west-2:327778747031:certificate/3630471e-0ca2-4aec-a7f1-ef78258c8283"
outbound_alb_certificate_arn="arn:aws:acm:eu-west-2:327778747031:certificate/67279db0-17f9-4517-8572-eb739ae6808b"
# this should temporarily overwrite the default raw-inbound
inbound_raw_queue_name = "js-inbound"