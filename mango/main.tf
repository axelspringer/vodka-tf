data "aws_ecs_task_definition" "gw" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.gw.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.gw"]
}

data "aws_ecs_task_definition" "ssr" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.ssr.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.ssr"]
}

data "aws_ecs_task_definition" "wp" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.wp.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.wp"]
}

data "template_file" "gw" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/definitions/gw.json.tpl")}"

  vars {
    name    = "mango_gw"
    cpu     = "${var.cpu}"
    mem_res = "${var.memory_reservation}"
    mem     = "${var.memory}"
    image   = "${var._image}"
    port    = "${var._container_port}"

    route53_zone = "${join(".", list("gw", "${var.cluster_name}-${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "gw"
  }
}

data "template_file" "ssr" {
  template = "${file("${path.module}/definitions/ssr.json.tpl")}"

  vars {
    name    = "mango_ssr"
    cpu     = "${var.cpu}"
    mem     = "${var.memory}"
    mem_res = "${var.memory_reservation}"
    image   = "${var._image}"
    port    = "${var._container_port}"

    route53_zone = "${join(".", list("ssr", "${var.cluster_name}-${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "ssr"
  }
}

data "template_file" "wp" {
  template = "${file("${path.module}/definitions/wp.json.tpl")}"

  vars {
    name    = "mango_wp"
    cpu     = "${var.cpu}"
    mem     = "${var.memory}"
    mem_res = "${var.memory_reservation}"
    image   = "${var._image}"
    port    = "${var._container_port}"

    route53_zone = "${join(".", list("wp", "${var.cluster_name}-${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "wp"
  }
}

resource "aws_ecs_task_definition" "gw" {
  count = "${length(var.branches)}"

  family = "${var.cluster_name}-mango-gw-${element(var.branches, count.index)}"

  container_definitions = "${element(data.template_file.gw.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_task_definition" "ssr" {
  count = "${length(var.branches)}"

  family = "${var.cluster_name}-mango-ssr-${element(var.branches, count.index)}"

  container_definitions = "${element(data.template_file.ssr.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_task_definition" "wp" {
  count = "${length(var.branches)}"

  family = "${var.cluster_name}-mango-wp-${element(var.branches, count.index)}"

  container_definitions = "${element(data.template_file.wp.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "ssr" {
  count           = "${length(var.cluster_ids)}"
  name            = "mango-ssr"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.ssr.*.family, count.index)}:${max("${element(aws_ecs_task_definition.ssr.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.ssr.*.revision, count.index)}")}"

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

resource "aws_ecs_service" "wp" {
  count           = "${length(var.cluster_ids)}"
  name            = "mango-wp"
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

resource "aws_ecs_service" "gateway" {
  count           = "${length(var.cluster_ids)}"
  name            = "mango-gw"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.gw.*.family, count.index)}:${max("${element(aws_ecs_task_definition.gw.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.gw.*.revision, count.index)}")}"

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
