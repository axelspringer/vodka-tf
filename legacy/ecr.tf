resource "aws_ecr_repository" "wp_be" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-legacy-wp-be-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "wp_be_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.wp_be.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_ecr_repository" "wp_fe" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-legacy-wp-fe-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "wp_fe_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.wp_fe.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}
