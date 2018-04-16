resource "aws_ecr_repository" "wp" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-legacy-wp-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "wp_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.wp.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}
