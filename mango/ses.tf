data "aws_iam_policy_document" "email" {
  count = "${length(var.branches)}"

  statement {
    sid = "AllowSendEmails"

    effect = "Allow"

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "email" {
  name        = "${var.cluster_name}-mango-email"
  description = "This allows to send emails from"
  policy      = "${data.aws_iam_policy_document.email.json}"
}

resource "aws_iam_user_policy_attachment" "email" {
  count      = "${length(var.branches)}"
  user       = "${element(aws_iam_user.email.*.name, count.index)}"
  policy_arn = "${element(aws_iam_policy.email.*.arn, count.index)}"
}

resource "aws_iam_user" "email" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-email-${element(var.branches, count.index)}"
}

resource "aws_iam_access_key" "email" {
  count = "${length(var.branches)}"
  user  = "${element(aws_iam_user.email.*.name, count.index)}"
}
