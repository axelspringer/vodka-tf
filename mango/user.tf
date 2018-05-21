data "aws_iam_policy_document" "read_trust_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true",
      ]
    }
  }
}

data "aws_iam_policy_document" "read_assume_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.read.arn}"]
  }
}

resource "aws_iam_role" "read" {
  name               = "${var.cluster_name}-mango-read"
  description        = "This role allows read access to all relevant resources"
  assume_role_policy = "${data.aws_iam_policy_document.read_trust_policy.json}"
}

resource "aws_iam_policy" "read_assume_policy" {
  name        = "${var.cluster_name}-mango-read"
  description = "This policy allows to assume the ${var.cluster_name}-mango-read role"
  policy      = "${data.aws_iam_policy_document.read_assume_policy.json}"
}

resource "aws_iam_role_policy_attachment" "read_cloudwatch_log_group" {
  role       = "${aws_iam_role.read.name}"
  policy_arn = "${aws_iam_policy.read_cloudwatch_log_group.arn}"
}

resource "aws_iam_role_policy_attachment" "read_codebuild" {
  count      = "${length(var.branches)}"
  policy_arn = "${element(aws_iam_policy.read_codebuild.*.arn, count.index)}"
  role       = "${aws_iam_role.read.name}"
}

resource "aws_iam_role_policy_attachment" "read_cloudwatch_log_group" {
  role       = "${aws_iam_role.read.name}"
  policy_arn = "${aws_iam_policy.read_cloudwatch_log_group.arn}"
}

resource "aws_iam_role_policy_attachment" "dev_cloudwatch_log_group" {
  count      = "${var.dev_role_name != "" ? 1 : 0}"
  role       = "${var.dev_role_name}"
  policy_arn = "${aws_iam_policy.read_cloudwatch_log_group.arn}"
}

resource "aws_iam_role_policy_attachment" "dev_cloudwatch_codebuild" {
  count      = "${var.dev_role_name != "" ? length(var.branches) : 0}"
  role       = "${var.dev_role_name}"
  policy_arn = "${element(aws_iam_policy.read_codebuild.*.arn, count.index)}"
}

resource "aws_iam_role_policy_attachment" "op_cloudwatch_log_group" {
  count      = "${var.op_role_name != "" ? 1 : 0}"
  role       = "${var.op_role_name}"
  policy_arn = "${aws_iam_policy.read_cloudwatch_log_group.arn}"
}

resource "aws_iam_role_policy_attachment" "op_cloudwatch_codebuild" {
  count      = "${var.op_role_name != "" ? length(var.branches) : 0}"
  role       = "${var.op_role_name}"
  policy_arn = "${element(aws_iam_policy.read_codebuild.*.arn, count.index)}"
}
