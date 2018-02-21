module "alb" {
  source = "../alb"

  name              = "${var.name}"
  cluster           = "${var.cluster}"
  vpc_id            = "${var.vpc_id}"
  public_subnet_ids = "${var.public_subnet_ids}"
}

resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "TCP"
  source_security_group_id = "${module.alb.alb_security_group_id}"
  security_group_id        = "${module.ecs_instances.ecs_instance_security_group_id}"
}
