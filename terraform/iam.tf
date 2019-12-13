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
  name               = "mhs"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-assume-role-policy.json}"
}

data "aws_iam_policy_document" "dynamodb-table-access" {
  statement {
    actions = [
      "dynamodb:*"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.environment_id}-mhs-state",
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.environment_id}-mhs-sync-async-state"
    ]
  }
}

resource "aws_iam_policy" "dynamodb-table-access" {
  name   = "dynamodb-table-access"
  policy = "${data.aws_iam_policy_document.dynamodb-table-access.json}"
}

resource "aws_iam_role_policy_attachment" "mhs_dynamo_attach" {
  role       = "${aws_iam_role.mhs.name}"
  policy_arn = aws_iam_policy.dynamodb-table-access.arn
}

resource "aws_iam_role" "mhs-as" {
  name               = "mhs-as"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-assume-role-policy.json}"
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
  name               = "mhsEcsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.mhs-ecs-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ssm-readonly-attach" {
  role       = "${aws_iam_role.mhs-ecs.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecs-task-exec-attach" {
  role       = "${aws_iam_role.mhs-ecs.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "read-secrets-manager" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:*",
    ]
  }
}

resource "aws_iam_policy" "read-secrets-manager" {
  name   = "read-secrets-manager"
  policy = "${data.aws_iam_policy_document.read-secrets-manager.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-read-secrets-attach" {
  role       = "${aws_iam_role.mhs-ecs.name}"
  policy_arn = aws_iam_policy.read-secrets-manager.arn
}
