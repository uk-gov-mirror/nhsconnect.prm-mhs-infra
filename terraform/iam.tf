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

resource "aws_iam_role_policy_attachment" "mhs_dynamo_attach" {
  role       = "${aws_iam_role.mhs.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role" "mhs-as" {
  name               = "mhs-as"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-assume-role-policy.json}"
}

locals {
  task_role_arn = aws_iam_role.mhs.arn
  task_scaling_role_arn = aws_iam_role.mhs-as.arn
  execution_role_arn = aws_iam_role.mhs-ecs.arn
}

# ECS Task Execution Role for MHS
# arn:aws:sts::327778747031:assumed-role/ecsTaskExecutionRole/201bb29b79194d1eb4f8c9110eee2bd2 is not authorized to perform:
# secretsmanager:GetSecretValue on resource: arn:aws:secretsmanager:eu-west-2:327778747031:secret:/nhs/dev/mhs/ca-certs-8kVsFA
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

#TODO: Use these perms for dynamodb to use it in test instance
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "mhs-test" {
  name               = "mhs-test"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "dynamo_attach" {
  role       = "${aws_iam_role.mhs-test.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  #FIXME: Limit access to selected tables
}

resource "aws_iam_instance_profile" "mhs-test" {
  name = "mhs-test"
  role = "${aws_iam_role.mhs-test.name}"
}
