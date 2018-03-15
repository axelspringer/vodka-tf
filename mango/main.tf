data "aws_ecs_task_definition" "gw" {
  task_definition = "${aws_ecs_task_definition.gw.family}"
  depends_on      = ["aws_ecs_task_definition.gw"]
}

data "aws_ecs_task_definition" "ssr" {
  task_definition = "${aws_ecs_task_definition.ssr.family}"
  depends_on      = ["aws_ecs_task_definition.ssr"]
}

data "aws_ecs_task_definition" "wp" {
  task_definition = "${aws_ecs_task_definition.wp.family}"
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
  family = "mango-gw"

  container_definitions = "${data.template_file.gw.rendered}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_task_definition" "ssr" {
  family = "mango-ssr"

  container_definitions = "${data.template_file.ssr.rendered}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_task_definition" "wp" {
  family = "mango-wp"

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
  name            = "mango-ssr"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${aws_ecs_task_definition.ssr.family}:${max("${aws_ecs_task_definition.ssr.revision}", "${data.aws_ecs_task_definition.ssr.revision}")}"

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
  name            = "mango-wp"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${aws_ecs_task_definition.wp.family}:${max("${aws_ecs_task_definition.wp.revision}", "${data.aws_ecs_task_definition.wp.revision}")}"

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
  name            = "mango-gateway"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${aws_ecs_task_definition.gw.family}:${max("${aws_ecs_task_definition.gw.revision}", "${data.aws_ecs_task_definition.gw.revision}")}"

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
