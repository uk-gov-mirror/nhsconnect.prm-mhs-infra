###################
# VPC endpoints
#
# The MHS VPC does not have public ip addresses,
# so in order to access various AWS services, we
# need to have some VPC endpoints. This keeps
# traffic to AWS services within the AWS network.
###################

# DynamoDB VPC endpoint
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id = local.mhs_vpc_id
  service_name = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [
    local.mhs_vpc_route_table_id
  ]

  tags = {
    Name = "${var.environment}-dynamodb-endpoint"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

# ECR VPC docker API endpoint
resource "aws_vpc_endpoint" "ecr_endpoint" {
  vpc_id = local.mhs_vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.ecr_security_group.id
  ]

  # An endpoint network interface is created in all of the subnets we have created.
  subnet_ids = local.subnet_ids

  tags = {
    Name = "${var.environment}-ecr-docker-endpoint"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

# ECR VPC API endpoint - needed for docker login
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id = local.mhs_vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.ecr_security_group.id
  ]

  # An endpoint network interface is created in all of the subnets we have created.
  subnet_ids = local.subnet_ids

  tags = {
    Name = "${var.environment}-ecr-api-endpoint"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

# S3 VPC endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = local.mhs_vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [
    local.mhs_vpc_route_table_id
  ]

  tags = {
    Name = "${var.environment}-s3-endpoint"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}

# Cloudwatch VPC endpoint
resource "aws_vpc_endpoint" "cloudwatch_endpoint" {
  vpc_id = local.mhs_vpc_id
  service_name = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.cloudwatch_security_group.id
  ]

  # An endpoint network interface is created in all of the subnets we have created.
  subnet_ids = local.subnet_ids

  tags = {
    Name = "${var.environment}-cloudwatch-endpoint"
    Environment = var.environment
    CreatedBy = var.repo_name
  }
}
