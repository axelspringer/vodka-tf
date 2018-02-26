module "ecs_instances" {
  source = "../ecs_instances"

  aws_ami                  = "${var.ecs_aws_ami}"
  cloudwatch_prefix        = "${var.cloudwatch_prefix}"
  cluster                  = "${var.cluster}"
  branches                 = "${var.branches}"
  custom_userdata          = "${var.custom_userdata}"
  desired_capacity         = ["${var.desired_capacity}"]
  iam_instance_profile_ids = ["${aws_iam_instance_profile.ecs.*.id}"]
  instance_group           = "${var.instance_group}"
  instance_type            = ["${var.instance_type}"]
  key_name                 = "${var.key_name}"
  max_size                 = ["${var.max_size}"]
  min_size                 = ["${var.min_size}"]
  private_subnet_ids       = ["${var.private_subnet_ids}"]
  vpc_id                   = "${var.vpc_id}"
}

resource "aws_ecs_cluster" "cluster" {
  count = "${length(var.branches)}"
  name  = "${var.cluster}-${element(var.branches, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}
