# + get data Cachet task definition
data "aws_ecs_task_definition" "default" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.default.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.default"]
}

# + get data Decrypt KMS encrypted database password
data "aws_kms_secret" "app" {
  secret {
    name    = "app_key"
    payload = "${var.rds_encrypted_password}" # passes in the KMS encrypted password

    context {
      project = "${var.rds_encrypted_password_context}" # this bound the context
    }
  }
}

# + get data Cachet task template
data "template_file" "default" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/definitions/cachet.json.tpl")}"

  vars {
    name    = "cachet"
    cpu     = "${var.cpu}"
    mem_res = "${var.memory_reservation}"
    mem     = "${var.memory}"
    image   = "${var._image}"
    port    = "${var._container_port}"

    route53_zone = "${join(".", list("cachet", "${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/cachet"
    log_region = "${data.aws_region.current.name}"

    app_key     = "${aws_kms_secret.app.app_key}"
    db_driver   = "mysql"
    db_username = "${var.rds_iam_user}"
    db_host     = "${element(module.db.db_route53_discovery_fqdn, count.index)}"
    db_database = "${var.rds_db_name}"
  }
}
