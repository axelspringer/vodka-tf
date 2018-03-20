# + get res DB Subnet Group
resource "aws_db_subnet_group" "default" {
  count = "${length(var.branches)}"

  name        = "${var.name}-${element(var.branches, count.index)}"
  description = "Database subnet group for ${var.name}-${element(var.branches, count.index)}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = "${merge(var.tags, map("Name", "${var.name}-${element(var.branches, count.index)}"))}"
}
