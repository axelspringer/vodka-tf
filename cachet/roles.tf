data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# + get res AWS IAM Role for the Cachet task
resource "aws_iam_role" "task" {
  count              = "${length(var.branches)}"
  name               = "${var.cluster_name}-${element(var.branches, count.index)}-task-cachet"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

# + get res AWS IAM Policy Attachment for Cachet task
resource "aws_iam_role_policy_attachment" "task" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.task.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.task.arn}"
}

# + get res AWS IAM Policy Attachment for RDS
resource "aws_iam_role_policy_attachment" "rds" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.task.*.name, count.index)}"
  policy_arn = "${element(module.db.db_policy_arns, count.index)}"
}

# + get res AWS IAM Policy for Cachet task
resource "aws_iam_policy" "task" {
  name        = "${var.cluster_name}-task-cachet"
  description = "Allow ECS task to call AWS APIs"
  policy      = "${data.aws_iam_policy_document.task_policy.json}"
}

# + get res AWS IAM Policy Document for Cachet task role
data "aws_iam_policy_document" "task_role" {
  statement {
    sid     = "ECSTaskRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# + get res AWS IAM Policy Document for Cachet task policy
data "aws_iam_policy_document" "task_policy" {
  statement {
    sid    = "ECSTaskPolicyKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = ["${var.kms_master_key_arn}"]
  }

  statement {
    sid    = "ECSTaskPolicy"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.cluster_name}-mango-*",
    ]
  }
}
