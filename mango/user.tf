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
  path               = "/ecs/"
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
