resource "null_resource" "let" {
  count = "${length(split(",",var.stages))}"
  triggers {
    raw = "${element(split(",", var.stages),count.index)}"
  }
}
resource "null_resource" "stages" {
  count = "${length(split(",",var.stages))}"
  triggers {
    branch = "${element(split(":",element(null_resource.let.*.triggers.raw, count.index)),0)}"
    stages = "${element(split(":",element(null_resource.let.*.triggers.raw, count.index)),1)}"
  }
}

locals { branches = "${distinct(null_resource.stages.*.triggers.branch)}" }

data "aws_ecs_task_definition" "wp" {
  count           = "${length(split(",",var.stages))}"
  task_definition = "${element(aws_ecs_task_definition.wp.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.wp"]
}

data "template_file" "wp" {
  count    = "${length(split(",",var.stages))}"
  template = "${file("${path.module}/definitions/wp_${null_resource.stages.*.triggers.stages[count.index]}.json.tpl")}"

  vars {
    name    = "legacy_wp_${null_resource.stages.*.triggers.stages[count.index]}"
    cpu     = "${var.cpu}"
    mem     = "${var.memory}"
    mem_res = "${var.memory_reservation}"
    image   = "${var._image}"
    port    = "80"

		wp_layer = "${null_resource.stages.*.triggers.stages[count.index]}"
		wp_origin = "http://wp_fe.master.foodbarn.konsum.zone/"
		environment = "${null_resource.stages.*.triggers.branch[count.index]}"
		#whitlist = ""

    templeton_path = "/${var.cluster_name}-${null_resource.stages.*.triggers.branch[count.index]}/legacy/wp_${null_resource.stages.*.triggers.stages[count.index]}"

    route53_zone = "${join(".", list("wp_${null_resource.stages.*.triggers.stages[count.index]}", "${null_resource.stages.*.triggers.branch[count.index]}", var.route53_zone))}"

    log_group  = "${var.cluster_name}-${null_resource.stages.*.triggers.branch[count.index]}/legacy"
    log_region = "${data.aws_region.current.name}"
    log_prefix = "wp_${null_resource.stages.*.triggers.stages[count.index]}"
  }
}

resource "aws_ecs_task_definition" "wp" {
  count           = "${length(split(",",var.stages))}"


  family = "${var.cluster_name}-legacy-wp-${null_resource.stages.*.triggers.stages[count.index]}-${null_resource.stages.*.triggers.branch[count.index]}"

  container_definitions = "${element(data.template_file.wp.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${element(aws_iam_role.task.*.arn, count.index)}"

  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}

resource "aws_ecs_service" "wp" {
  count           = "${length(split(",",var.stages))}"

  name            = "legacy-wp-${null_resource.stages.*.triggers.stages[count.index]}"
  cluster         = "arn:aws:ecs:eu-west-1:188769813531:cluster/foodbarn-prod-${null_resource.stages.*.triggers.branch[count.index]}"
  desired_count   = "${var.size}"
  task_definition = "${element(aws_ecs_task_definition.wp.*.family, count.index)}:${max("${element(aws_ecs_task_definition.wp.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.wp.*.revision, count.index)}")}"

  # iam_role        = "${aws_iam_role.default.arn}"

  # workaround to ignore changes made through pipeline deployments
  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["task_definition"]
  }

  placement_strategy {
    type  = "${var.placement_strategy_type}"
    field = "${var.placement_strategy_field}"
  }
  placement_constraints {
    type       = "${var.placement_constraint_type}"
    expression = "${var.placement_constraint_expression}"
  }
}
