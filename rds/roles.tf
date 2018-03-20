resource "aws_iam_role" "default" {
  count              = "${length(var.branches)}"
  name               = "${var.name}-db-${element(var.branches, count.index)}"
  assume_role_policy = "${element(data.aws_iam_policy_document.default_role.*.json, count.index)}"
}

resource "aws_iam_policy" "default" {
  count       = "${length(var.branches)}"
  name        = "${var.name}-db-${element(var.branches, count.index)}"
  path        = "/"
  description = "IAM policy for ${var.name}-db-${element(var.branches, count.index)}"
  policy      = "${element(data.aws_iam_policy_document.default_policy.*.json, count.index)}"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.default.*.name, count.index)}"
  policy_arn = "${element(aws_iam_policy.default.*.arn, count.index)}"
}

data "aws_iam_policy_document" "default_role" {
  statement {
    sid     = "RDSRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "default_policy" {
  count = "${length(var.branches)}"

  statement {
    sid = "RDS"

    effect  = "Allow"
    actions = ["rds-db:connect"]

    resources = [
      "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${element(module.instance.db_instance_resource_id, count.index)}/${var.iam_user}",
    ]
  }
}
