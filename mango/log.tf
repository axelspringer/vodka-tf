# + get res Cloudwatch for the branches
resource "aws_cloudwatch_log_group" "default" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
}
