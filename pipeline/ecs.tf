module "ecs" {
  source = "../ecs"

  name               = "${var.name}"
  vpc_id             = "${var.ecs_vpc_id}"
  desired_capacity   = ["${var.ecs_esired_capacity}"]
  max_size           = ["${var.ecs_min_size}"]
  min_size           = ["${var.ecs_max_size}"]
  instance_type      = ["${var.ecs_instance_type}"]
  availability_zones = ["${var.ecs_availability_zones}"]
  public_subnet_ids  = ["${var.ecs_public_subnet_ids}"]
  private_subnet_ids = ["${var.ecs_private_subnet_ids}"]
  ecs_aws_ami        = "${var.ecs_ami}"
  key_name           = "${var.ecs_instance_key_name}"
  branches           = ["${var.branches}"]
}
