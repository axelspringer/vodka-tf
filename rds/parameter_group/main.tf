# + get rest DB Parameter Group
resource "aws_db_parameter_group" "default" {
  count = "${length(var.branches)}" # use branches

  name        = "${var.name}-${element(var.branches, count.index)}"
  description = "Database parameter group for ${var.name}-${element(var.branches, count.index)}"
  family      = "${var.family}"

  parameter = [
    "${var.parameters}",
  ]

  tags = "${merge(var.tags, map("Name", "${var.name}-${element(var.branches, count.index)}"))}"

  lifecycle {
    create_before_destroy = true
  }
}
