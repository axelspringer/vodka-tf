data "aws_ecs_task_definition" "mango_api" {
  task_definition = "${aws_ecs_task_definition.mango_api.family}"
  depends_on      = ["aws_ecs_task_definition.mango_api"]
}

data "template_file" "mango_definition" {
  template = "${file("${path.module}/definitions/mango.json.tpl")}"

  vars {
    name  = "mango_api"
    cpu   = "${var.cpu}"
    mem   = "${var.memory}"
    image = "${var._image}"
    port  = "${var._container_port}"
  }
}

resource "aws_ecs_cluster" "default" {
  name = "${var.cluster_name}"
}

resource "aws_ecs_task_definition" "mango_api" {
  family = "mango"

  container_definitions = "${data.template_file.mango_definition.rendered}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "mango" {
  name            = "mango-api"
  cluster         = "${var.cluster_id}"
  desired_count   = "${var.size}"
  task_definition = "${aws_ecs_task_definition.mango_api.family}:${max("${aws_ecs_task_definition.mango_api.revision}", "${data.aws_ecs_task_definition.mango_api.revision}")}"
  iam_role        = "${aws_iam_role.default.arn}"

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }

  load_balancer {
    target_group_arn = "${var.alb_target_group}"
    container_name   = "${var._container_name}"
    container_port   = "${var._container_port}"
  }

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}
