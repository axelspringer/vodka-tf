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
  template = "${file("${path.module}/definitions/gw.json.tpl")}"

  vars {
    name  = "mango_gw"
    cpu   = "${var.cpu}"
    mem   = "${var.memory}"
    image = "${var._image}"
    port  = "${var._container_port}"
  }
}

data "template_file" "ssr" {
  template = "${file("${path.module}/definitions/ssr.json.tpl")}"

  vars {
    name  = "mango_ssr"
    cpu   = "${var.cpu}"
    mem   = "${var.memory}"
    image = "${var._image}"
    port  = "${var._container_port}"
  }
}

data "template_file" "wp" {
  template = "${file("${path.module}/definitions/wp.json.tpl")}"

  vars {
    name  = "mango_wp"
    cpu   = "${var.cpu}"
    mem   = "${var.memory}"
    image = "${var._image}"
    port  = "${var._container_port}"
  }
}

resource "aws_ecs_task_definition" "gw" {
  count = "${length(var.branches)}"

  family = "mango-gw-${element(var.branches, count.index)}"

  container_definitions = "${data.template_file.gw.rendered}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_task_definition" "ssr" {
  count = "${length(var.branches)}"

  family = "mango-ssr-${element(var.branches, count.index)}"

  container_definitions = "${data.template_file.ssr.rendered}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_task_definition" "wp" {
  count = "${length(var.branches)}"

  family = "mango-wp-${element(var.branches, count.index)}"

  container_definitions = "${data.template_file.wp.rendered}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "ssr" {
  count           = "${length(var.cluster_ids)}"
  name            = "mango-ssr-${element(var.branches, count.index)}"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.ssr.*.family, count.index)}:${max("${element(aws_ecs_task_definition.ssr.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.ssr.*.revision, count.index)}")}"

  # iam_role        = "${aws_iam_role.default.arn}"

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  load_balancer {
    target_group_arn = "${element(module.alb_ssr.default_alb_target_groups, count.index)}"
    container_name   = "mango_ssr"
    container_port   = "${var._container_port}"
  }
  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
  depends_on = ["module.alb_ssr"]
}

resource "aws_ecs_service" "wp" {
  count           = "${length(var.cluster_ids)}"
  name            = "mango-wp-${element(var.branches, count.index)}"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.wp.*.family, count.index)}:${max("${element(aws_ecs_task_definition.wp.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.wp.*.revision, count.index)}")}"

  # iam_role        = "${aws_iam_role.default.arn}"

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  load_balancer {
    target_group_arn = "${element(module.alb_wp.default_alb_target_groups, count.index)}"
    container_name   = "mango_wp"
    container_port   = "${var._container_port}"
  }
  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
  depends_on = ["module.alb_wp"]
}

resource "aws_ecs_service" "gateway" {
  count           = "${length(var.cluster_ids)}"
  name            = "mango-gw-${element(var.branches, count.index)}"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.gw.*.family, count.index)}:${max("${element(aws_ecs_task_definition.gw.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.gw.*.revision, count.index)}")}"

  # iam_role        = "${aws_iam_role.default.arn}"

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  load_balancer {
    target_group_arn = "${element(module.alb_gw.default_alb_target_groups, count.index)}"
    container_name   = "mango_gw"
    container_port   = "${var._container_port}"
  }
  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
  depends_on = ["module.alb_gw"]
}
