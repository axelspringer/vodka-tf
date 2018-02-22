data "aws_iam_policy_document" "role" {
  statement {
    sid     = "1"

    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid     = "1"

    effect  = "Allow"
    actions = ["ssm:DescribeParameters"]

    resources = [
      "*",
    ]
  }

  statement {
    sid     = "2"

    effect  = "Allow"
    actions = ["ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.prefix}*"
    ]
  }
}

data "aws_caller_identity" "current" { }

data "aws_region" "current" {
  current = true
}

resource "aws_iam_role" "default" {
  name = "${var.cluster}_default_task"
  path = "/ecs/"

  assume_role_policy = "${aws_iam_policy_document.role.json}"
}

resource "aws_iam_policy" "default" {
  name = "${var.cluster}_ecs_default_task"
  path = "/"

  policy = "${aws_iam_policy_document.policy.json}"
}

resource "aws_iam_policy_attachment" "default" {
  name       = "${var.cluster}_ecs_default_task"
  roles      = ["${aws_iam_role.default.name}"]
  policy_arn = "${aws_iam_policy.default.arn}"
}
