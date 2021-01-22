resource "aws_ecs_cluster" "mhs_route_cluster" {
  name = "${var.environment}-${var.cluster_name}-mhs-route-cluster"

  tags = {
    Name = "${var.environment}-${var.cluster_name}-mhs-cluster"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

resource "aws_cloudwatch_log_group" "mhs_route_log_group" {
  name = "/ecs/${var.environment}-${var.cluster_name}-mhs-route"
  tags = {
    Name = "${var.environment}-${var.cluster_name}-mhs-route-log-group"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

resource "aws_ecs_task_definition" "mhs_route_task" {
  family = "${var.environment}-${var.cluster_name}-mhs-route"
  container_definitions = jsonencode(
  [
    {
      name = "mhs-route"
      image = "${local.ecr_address}/mhs-route:${var.build_id}"
      environment = [
        {
          name = "DNS_SERVER_1",
          value = local.dns_ip_address_0
        },
        {
          name = "DNS_SERVER_2",
          value = local.dns_ip_address_1
        },
        {
          name = "MHS_LOG_LEVEL"
          value = var.mhs_log_level
        },
        {
          name = "MHS_SDS_URL"
          value = var.spineroutelookup_service_sds_url
        },
        {
          name = "MHS_SDS_SEARCH_BASE"
          value = var.spineroutelookup_service_search_base
        },
        {
          name = "MHS_DISABLE_SDS_TLS"
          value = var.spineroutelookup_service_disable_sds_tls
        },
        {
          name = "MHS_SDS_REDIS_CACHE_HOST"
          value = aws_elasticache_replication_group.elasticache_replication_group.primary_endpoint_address
        },
        {
          name = "MHS_SDS_REDIS_CACHE_PORT"
          value = tostring(aws_elasticache_replication_group.elasticache_replication_group.port)
        }
      ]
      secrets = [
        {
          name = "MHS_SECRET_CLIENT_CERT"
          valueFrom = local.client_cert_arn
        },
        {
          name = "MHS_SECRET_CLIENT_KEY"
          valueFrom = local.client_key_arn
        },
        {
          name = "MHS_SECRET_CA_CERTS"
          valueFrom = local.ca_certs_arn
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.mhs_route_log_group.name
          awslogs-region = var.region
          awslogs-stream-prefix = var.build_id
        }
      }
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
          protocol = "tcp"
        }
      ]
    }
  ]
  )
  cpu = "512"
  memory = "1024"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  tags = {
    Name = "${var.environment}-mhs-route-task"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
  task_role_arn = local.task_role_arn
  execution_role_arn = local.execution_role_arn
}

resource "aws_security_group" "mhs_route" {
  name = "${var.environment}-${var.cluster_name}-mhs-route"
  description = "The security group used to control traffic for the MHS Routing component."
  vpc_id = local.mhs_vpc_id

  tags = {
    Name = "${var.environment}-mhs-route-sg"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

resource "aws_security_group_rule" "mhs_inbound_access_to_elasticache" {
  type              = "ingress"
  from_port = 6379
  to_port = 6379
  protocol          = "tcp"
  source_security_group_id = aws_security_group.mhs_route.id
  security_group_id = aws_security_group.sds_cache.id
  description = "Allow Redis requests from MHS route task"
}