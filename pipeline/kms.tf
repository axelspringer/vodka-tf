resource "aws_kms_key" "s3key" {
  count                   = "${length(var.branches)}"
  description             = "${var.name}-pipeline-${element(var.branches, count.index)}"
  deletion_window_in_days = 10
}
