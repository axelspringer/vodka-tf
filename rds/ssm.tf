resource "aws_ssm_parameter" "ssm_host" {
	count = "${length(var.branches)}"
  name  = "/${var.ssm_project}-${element(var.branches, count.index)}/${var.ssm_path}/db_host"

  type  = "String"
  value = "${element(module.instance.db_instance_endpoint, count.index)}"
}

resource "aws_ssm_parameter" "ssm_user" {
	count = "${length(var.branches)}"
  name  = "/${var.ssm_project}-${element(var.branches, count.index)}/${var.ssm_path}/db_user"

  type  = "String"
  value = "${var.username}"
}

resource "aws_ssm_parameter" "ssm_db_name" {
	count = "${length(var.branches)}"
  name  = "/${var.ssm_project}-${element(var.branches, count.index)}/${var.ssm_path}/db_name"

  type  = "String"
  value = "${var.db_name}"
}
