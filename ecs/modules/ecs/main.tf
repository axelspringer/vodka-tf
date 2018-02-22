module "ecs_instances" {
  source = "../ecs_instances"

  aws_ami                 = "${var.ecs_aws_ami}"
  cloudwatch_prefix       = "${var.cloudwatch_prefix}"
  cluster                 = "${var.cluster}"
  custom_userdata         = "${var.custom_userdata}"
  desired_capacity        = "${var.desired_capacity}"
  iam_instance_profile_id = "${aws_iam_instance_profile.ecs.id}"
  instance_group          = "${var.instance_group}"
  instance_type           = "${var.instance_type}"
  key_name                = "${var.key_name}"
  load_balancers          = "${var.load_balancers}"
  max_size                = "${var.max_size}"
  min_size                = "${var.min_size}"
  private_subnet_ids      = "${var.private_subnet_ids}"
  vpc_id                  = "${var.vpc_id}"
}

module "ecs_roles" {
  source = "../ecs_roles"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}"
}
