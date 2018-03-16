resource "aws_ecr_repository" "ssr" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-ssr-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "ssr_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.ssr.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_ecr_repository" "wp" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-wp-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "wp_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.wp.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_ecr_repository" "gw" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-gw-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "gw_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.gw.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}
