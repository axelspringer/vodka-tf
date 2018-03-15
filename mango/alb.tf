module "alb_gw" {
  source = "../ecs_alb"

  branches                   = "${var.branches}"
  instance_security_group_id = "${var.instance_security_group_id}"
  name                       = "${var.cluster_name}-m-gw"
  public_subnet_ids          = ["${var.public_subnet_ids}"]
  vpc_id                     = "${var.vpc_id}"
}

module "alb_ssr" {
  source = "../ecs_alb"

  branches                   = "${var.branches}"
  instance_security_group_id = "${var.instance_security_group_id}"
  name                       = "${var.cluster_name}-m-ssr"
  public_subnet_ids          = ["${var.public_subnet_ids}"]
  vpc_id                     = "${var.vpc_id}"
}

module "alb_wp" {
  source = "../ecs_alb"

  branches                   = "${var.branches}"
  instance_security_group_id = "${var.instance_security_group_id}"
  name                       = "${var.cluster_name}-m-wp"
  public_subnet_ids          = ["${var.public_subnet_ids}"]
  vpc_id                     = "${var.vpc_id}"
}
