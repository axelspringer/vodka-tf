data "aws_ecs_task_definition" "wp_be" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.wp_be.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.wp_be"]
}

data "template_file" "wp_be" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/definitions/wp_be.json.tpl")}"

  vars {
    name    = "legacy_wp_be"
    cpu     = "${var.cpu}"
    mem     = "${var.memory}"
    mem_res = "${var.memory_reservation}"
    image   = "${var._image}"
    port    = "80"

    templeton_path = "/${var.cluster_name}-${element(var.branches, count.index)}/legacy/wp_be"

    route53_zone = "${join(".", list("wp_be", "${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/legacy"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "wp_be"
  }
}

resource "aws_ecs_task_definition" "wp_be" {
  count = "${length(var.branches)}"

  family = "${var.cluster_name}-legacy-wp-be-${element(var.branches, count.index)}"

  container_definitions = "${element(data.template_file.wp_be.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "wp_be" {
  count           = "${length(var.cluster_ids)}"
  name            = "legacy-wp-be"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.wp_be.*.family, count.index)}:${max("${element(aws_ecs_task_definition.wp_be.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.wp_be.*.revision, count.index)}")}"

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

data "aws_ecs_task_definition" "wp_fe" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.wp_fe.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.wp_fe"]
}

data "template_file" "wp_fe" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/definitions/wp_fe.json.tpl")}"

  vars {
    name    = "legacy_wp_fe"
    cpu     = "${var.cpu}"
    mem     = "${var.memory}"
    mem_res = "${var.memory_reservation}"
    image   = "${var._image}"
    port    = "80"

    templeton_path = "/${var.cluster_name}-${element(var.branches, count.index)}/legacy/wp_fe"

    route53_zone = "${join(".", list("wp_fe", "${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/legacy"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "wp_fe"
  }
}

resource "aws_ecs_task_definition" "wp_fe" {
  count = "${length(var.branches)}"

  family = "${var.cluster_name}-legacy-wp-fe-${element(var.branches, count.index)}"

  container_definitions = "${element(data.template_file.wp_fe.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "wp_fe" {
  count           = "${length(var.cluster_ids)}"
  name            = "legacy-wp-fe"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.wp_fe.*.family, count.index)}:${max("${element(aws_ecs_task_definition.wp_fe.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.wp_fe.*.revision, count.index)}")}"

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
