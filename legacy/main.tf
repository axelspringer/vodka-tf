data "aws_ecs_task_definition" "wp" {
  count           = "${length(var.stagename)}"
  task_definition = "${element(aws_ecs_task_definition.wp.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.wp"]
}

data "template_file" "wp" {
  count    = "${length(var.stagename)}"
  template = "${file("${path.module}/definitions/wp_${element(var.stagename, count.index)}.json.tpl")}"

  vars {
    name    = "legacy_wp_${element(var.stagename, count.index)}"
    cpu     = "${var.cpu}"
    mem     = "${var.memory}"
    mem_res = "${var.memory_reservation}"
    image   = "${var._image}"
    port    = "80"

    templeton_path = "/${var.cluster_name}-${element(var.branches, count.index)}/legacy/wp_${element(var.stagename, count.index)}"

    route53_zone = "${join(".", list("wp_${element(var.stagename, count.index)}", "${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/legacy"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "wp_${element(var.stagename, count.index)}"
  }
}

resource "aws_ecs_task_definition" "wp" {
  count           = "${length(var.stagename) * length(var.branches)}"

  family = "${var.cluster_name}-legacy-wp-${element(var.stagename, count.index / length(var.branches))}-${element(var.branches, count.index)}"

  container_definitions = "${element(data.template_file.wp.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "wp" {
  count           = "${length(var.stagename) * length(var.branches)}"
  name            = "legacy-wp-${element(var.stagename, count.index / length(var.stagename))}"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.wp.*.family, count.index)}:${max("${element(aws_ecs_task_definition.wp.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.wp.*.revision, count.index)}")}"

  # iam_role        = "${aws_iam_role.default.arn}"

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}
