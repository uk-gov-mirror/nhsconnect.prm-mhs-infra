data "aws_iam_policy_document" "ecs-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "mhs" {
  name               = "mhs-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs-assume-role-policy.json
}

data "aws_iam_policy_document" "dynamodb-table-access" {
  statement {
    actions = [
      "dynamodb:*"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.environment}-mhs-state",
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.environment}-mhs-sync-async-state"
    ]
  }
}

resource "aws_iam_policy" "dynamodb-table-access" {
  name   = "mhs-${var.environment}-dynamodb-table-access"
  policy = data.aws_iam_policy_document.dynamodb-table-access.json
}

resource "aws_iam_role_policy_attachment" "mhs_dynamo_attach" {
  role       = aws_iam_role.mhs.name
  policy_arn = aws_iam_policy.dynamodb-table-access.arn
}

resource "aws_iam_role" "mhs-as" {
  name               = "mhs-as-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs-assume-role-policy.json
}

# ECS Task Execution Role for MHS
data "aws_iam_policy_document" "mhs-ecs-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "mhs-ecs" {
  name               = "mhs-${var.environment}-EcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.mhs-ecs-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ssm-readonly-attach" {
  role       = aws_iam_role.mhs-ecs.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecs-task-exec-attach" {
  role       = aws_iam_role.mhs-ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "read-secrets" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/*",
    ]
  }
}

resource "aws_iam_policy" "read-secrets" {
  name   = "mhs-${var.environment}-read-secrets"
  policy = data.aws_iam_policy_document.read-secrets.json
}

resource "aws_iam_role_policy_attachment" "ecs-read-secrets-attach" {
  role       = aws_iam_role.mhs-ecs.name
  policy_arn = aws_iam_policy.read-secrets.arn
}
