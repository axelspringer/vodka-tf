# + get res Cloudwatch for the branches
resource "aws_cloudwatch_log_group" "default" {
  count             = "${length(distinct(null_resource.stages.*.triggers.branch))}"
  name              = "${var.cluster_name}-${element(local.branches, count.index)}/legacy"
  retention_in_days = "${var._task_log_retention_in_days}"
}
