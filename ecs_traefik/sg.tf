# + get res AWS ECS container instance security
resource "aws_security_group_rule" "web" {
  count             = "${var.enable_web}"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  cidr_blocks       = ["${concat(var.vpc_cidr_vpn_subnet)}"]
  security_group_id = "${var.instance_security_group_id}"
}

# + get res AWS ECS and allow
resource "aws_security_group_rule" "traefik" {
  count                    = "${var.enable_web}"
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "TCP"
  source_security_group_id = "${var.instance_security_group_id}"
  security_group_id        = "${var.instance_security_group_id}"
}
