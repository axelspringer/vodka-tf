# + get data AWS current region
data "aws_region" "current" {}

# + get data AWS current account
data "aws_caller_identity" "current" {}

# + get module ALB for Traefik
module "alb" {
  source = "../ecs_alb"

  branches          = "${var.branches}"
  name              = "${var.cluster_name}-t"
  health_check_path = "/ping"

  vpc_id                     = "${var.vpc_id}"
  public_subnet_ids          = ["${var.vpc_public_subnet_ids}"]
  instance_security_group_id = "${var.instance_security_group_id}"
  enable_stickiness          = true
  certificate_arns           = ["${data.aws_acm_certificate.default.*.arn}"]

  enable_traefik = true
}

# + get res AWS ECS service for Traefik
resource "aws_ecs_service" "traefik" {
  count           = "${length(var.cluster_ids)}"
  name            = "traefik"
  cluster         = "${element(var.cluster_ids, count.index)}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.traefik.*.family, count.index)}:${max("${element(aws_ecs_task_definition.traefik.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.traefik.*.revision, count.index)}")}"

  # iam_role        = "${aws_iam_role.default.arn}"

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  load_balancer {
    target_group_arn = "${element(module.alb.default_alb_target_groups, count.index)}"
    container_name   = "traefik"
    container_port   = "${var.port_http}"
  }
  placement_constraints {
    type = "${var.placement_constraint_type}"
  }
  depends_on = ["module.alb"]
}

# + get res AWS ECS task definition of Traefik
resource "aws_ecs_task_definition" "traefik" {
  count = "${length(var.branches)}"

  family = "${var.cluster_name}-${element(var.branches, count.index)}-traefik"

  container_definitions = "${element(data.template_file.traefik.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"
}

# + get data AWS ECS task definition of Traefik
data "aws_ecs_task_definition" "traefik" {
  count           = "${length(var.branches)}"
  task_definition = "${element(aws_ecs_task_definition.traefik.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.traefik"]
}

# + get data AWS ECS task definition template of Traefik
data "template_file" "traefik" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/traefik.json.tpl")}"

  vars {
    name           = "traefik"
    cpu            = "${var.cpu}"
    mem_res        = "${var.memory_reservation}"
    mem            = "${var.memory}"
    port_web       = "${var.port_web}"
    port_http      = "${var.port_http}"
    port_https     = "${var.port_https}"
    cluster_name   = "${var.cluster_name}-${element(var.branches, count.index)}"
    cluster_region = "${data.aws_region.current.name}"

    log_group  = "${var.cluster_name}-${element(var.branches, count.index)}/traefik"
    log_region = "${data.aws_region.current.name}"

    image = "${var._image}"
  }
}
