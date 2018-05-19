data "aws_iam_policy_document" "read_cloudwatch_log_group" {
  statement {
    sid    = "ReadCloudWatchLogStream"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeMetricFilters",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ReadCloudWatchLogGroup"
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.arn}"]
  }
}

# + get res Cloudwatch for the branches
resource "aws_cloudwatch_log_group" "default" {
  count             = "${length(var.branches)}"
  name              = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
  retention_in_days = "${var._task_log_retention_in_days}"
}

resource "aws_iam_policy" "read_cloudwatch_log_group" {
  name        = "${var.cluster_name}-mango-read-cloudwatch-loggroup"
  description = "This policy allows to read mango Cloudwatch Logs"
  policy      = "${data.aws_iam_policy_document.read_cloudwatch_log_group.json}"
}
