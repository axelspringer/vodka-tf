data "aws_ecs_task_definition" "mango_api" {
  task_definition = "${aws_ecs_task_definition.mango_api.family}"
}

data "aws_ecs_container_definition" "mango_api" {
  task_definition = "${aws_ecs_task_definition.mango_api.id}"
  container_name  = "mango-api"
}

resource "aws_ecs_cluster" "default" {
  name = "${var.cluster_name}"
}

resource "aws_ecs_task_definition" "mango_api" {
  family = "mango"

  container_definitions = "${file("definitions/mango.json")}"
}

resource "aws_ecs_service" "mango" {
  name          = "mango-api"
  cluster       = "${var.cluser_id}"
  desired_count = "${var.size}"
  task_definition = "${aws_ecs_task_definition.mango_api.family}:${max("${aws_ecs_task_definition.mango_api.revision}", "${data.aws_ecs_task_definition.mango_api.revision}")}"
  iam_role        = "${aws_iam_role.foo.arn}"
  depends_on      = ["aws_iam_role_policy.foo"]

  placement_strategy {
    type  = "${var.placement_type}"
    field = "${var.placement_field}"
  }

  load_balancer {
    target_group_arn  = "${var.alb_arn}"
    container_name    = ""
    container_port    = 8080
  }

  placement_constraints {
    type       = "${placement_constraint_type}"
    expression = "${placement_constraint_expression}"
  }
}
