data "template_file" "widgets" {
  template = "${file("${path.module}/widgets.tpl")}"
}

data "template_file" "dashboard_overview" {
  template = "${file("${path.module}/templates/axelspringer-totaloverview_2.json")}"

  vars {
    name = "${var.name}"
  }
}

resource "aws_cloudwatch_dashboard" "default" {
  dashboard_name = "${var.name}"
  dashboard_body = "${data.template_file.widgets.rendered}"
}

resource "aws_cloudwatch_dashboard" "axelspringer-totaloverview_2" {
  dashboard_name = "${var.name}-totaloverview_2"
  dashboard_body = "${data.template_file.totaloverview_2.rendered}"
}