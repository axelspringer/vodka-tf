# + get res Cloudwatch for the branches
resource "aws_cloudwatch_log_group" "default" {
  count             = "${length(var.branches)}"
  name              = "${var.cluster_name}-${element(var.branches, count.index)}/traefik"
  retention_in_days = "${var._task_log_retention_in_days}"
}
