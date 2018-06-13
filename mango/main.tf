locals {
  default_task_resources = {
    // gw
    gw_cpu                = 128
    gw_memory             = 128
    gw_memory_reservation = 64

    // wp
    wp_cpu                = 128
    wp_memory             = 128
    wp_memory_reservation = 64

    // ssr
    ssr_cpu                = 128
    ssr_memory             = 128
    ssr_memory_reservation = 64
  }

  task_resources = "${merge(local.default_task_resources, var.task_resources)}"
}

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
    cpu     = "${local.task_resources["gw_cpu"]}"
    mem_res = "${local.task_resources["gw_memory_reservation"]}"
    mem     = "${local.task_resources["gw_memory"]}"
    image   = "${var._image}"
    port    = "${var._container_port}"

    route53_zone = "${join(".", list("gw", "${element(var.branches, count.index)}", var.route53_zone))}"

    templeton_path = "/${var.cluster_name}-${element(var.branches, count.index)}/mango/gw"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "gw"
  }
}

data "template_file" "ssr" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/definitions/ssr.json.tpl")}"

  vars {
    name    = "mango_ssr"
    cpu     = "${local.task_resources["ssr_cpu"]}"
    mem_res = "${local.task_resources["ssr_memory_reservation"]}"
    mem     = "${local.task_resources["ssr_memory"]}"
    image   = "${var._image}"
    port    = "${var._container_port}"

    templeton_path = "/${var.cluster_name}-${element(var.branches, count.index)}/mango/ssr"

    route53_zone = "${join(".", list("ssr", "${element(var.branches, count.index)}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/mango"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "ssr"
  }
}

data "template_file" "wp" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/definitions/wp.json.tpl")}"

  vars {
    name    = "mango_wp"
    cpu     = "${local.task_resources["wp_cpu"]}"
    mem_res = "${local.task_resources["wp_memory_reservation"]}"
    mem     = "${local.task_resources["wp_memory"]}"
    image   = "${var._image}"
    port    = "80"
		whitelist = "${var.whitelist}"

    templeton_path = "/${var.cluster_name}-${element(var.branches, count.index)}/mango/wp"

    route53_zone = "${join(".", list("wp", "${element(var.branches, count.index)}", var.route53_zone))}"

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

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

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

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

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

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["task_definition"]
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
  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["task_definition"]
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
  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["task_definition"]
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
