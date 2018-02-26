data "aws_iam_policy_document" "role" {
  statement {
    sid = "1"

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
    sid = "1"

    effect  = "Allow"
    actions = ["ssm:DescribeParameters"]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "2"

    effect  = "Allow"
    actions = ["ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.prefix}*",
    ]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  current = true
}

resource "aws_iam_role" "default" {
  count              = "${length(var.branches)}"
  name               = "${var.cluster}-${element(var.branches, count.index)}-default-task"
  path               = "/ecs/"
  assume_role_policy = "${data.aws_iam_policy_document.role.json}"
}

resource "aws_iam_policy" "default" {
  count = "${length(var.branches)}"
  name  = "${var.cluster}-${element(var.branches, count.index)}-default-task"
  path  = "/"

  policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_policy_attachment" "default" {
  count      = "${length(var.branches)}"
  name       = "${var.cluster}-${element(var.branches, count.index)}-default-task"
  roles      = ["${element(aws_iam_role.default.*.id, count.index)}"]
  policy_arn = "${element(aws_iam_policy.default.*.id, count.index)}"
}
