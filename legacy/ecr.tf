resource "aws_ecr_repository" "wp" {
  count = "${length(split(",",var.stages))}"

  name  = "${var.cluster_name}-legacy-wp-${null_resource.stages.*.triggers.stages[count.index]}-${null_resource.stages.*.triggers.branch[count.index]}"
}

resource "aws_ecr_repository_policy" "wp_ecr" {
  count      = "${length(split(",",var.stages))}"
  repository = "${element(aws_ecr_repository.wp.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}
