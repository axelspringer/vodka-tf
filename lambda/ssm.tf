resource "aws_ssm_parameter" "default" {
  count = "${length(keys(var.ssm_parameters))}"
  name  = "${join("/", list(var.name, element(keys(var.ssm_parameters), count.index)))}"
  type  = "String"
  value = "${lookup(var.ssm_parameters, element(keys(var.ssm_parameters), count.index), "")}"
}
