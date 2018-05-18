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
  }
}

data "aws_iam_policy_document" "read_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-mango-read",
      ]
    }
  }
}

resource "aws_iam_role" "read" {
  name        = "${var.cluster_name}-mango-read"
  description = "This role allows read access to all relevant resources"
  path        = "/ecs/"

  assume_role_policy = "${data.aws_iam_policy_document.read_trust_policy.json}"
}

resource "aws_iam_policy" "read_assume_policy" {
  name        = "${var.cluster_name}-mango-read"
  description = "This policy allows to assume the ${var.cluster_name}-mango-read role"
  policy      = "${data.aws_iam_policy_document.read_assume_policy.json}"
}
