resource "aws_iam_role" "default" {
  count              = "${length(var.branches)}"
  name               = "${var.name}-rds-${element(var.branches, count.index)}"
  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.default.*.name, count.index)}"
  policy_arn = "${data.aws_iam_policy.default.arn}"
}

data "aws_iam_policy" "default" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = "RDS"

    effect = "Allow"

    principals = {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
