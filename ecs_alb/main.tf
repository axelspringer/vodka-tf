resource "aws_alb_target_group" "default" {
  count                = "${length(var.branches)}"
  name                 = "${var.name}-${element(var.branches, count.index)}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "HTTP"
  }
}

resource "aws_alb" "alb" {
  count           = "${length(var.branches)}"
  name            = "${var.name}-${element(var.branches, count.index)}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.alb.id}"]
  enable_http2    = "${var._enable_http2}"
}

resource "aws_alb_listener" "http" {
  count             = "${length(var.branches)}"
  load_balancer_arn = "${element(aws_alb.alb.*.id, count.index)}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.default.*.arn, count.index)}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "dashboard_http" {
  count             = "${var.enable_dashboard}"
  count             = "${length(var.branches)}"
  load_balancer_arn = "${element(aws_alb.alb.*.id, count.index)}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.default.*.arn, count.index)}"
    type             = "forward"
  }
}

# resource "aws_alb_listener" "https" {
#   count             = "${length(var.branches)}"
#   load_balancer_arn = "${element(aws_alb.alb.*.id, count.index)}"
#   port              = "443"
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = "${element(aws_alb_target_group.default.*.id, count.index)}"
#     type             = "forward"
#   }
# }

resource "aws_security_group" "alb" {
  name   = "${var.name}-alb"
  vpc_id = "${var.vpc_id}"

  tags = "${ merge( var.tags, map( "Name", var.name ), map( "Terraform", "true" ) ) }"
}

resource "aws_security_group_rule" "https_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "dashboard_from_anywhere" {
  count             = "${var.enable_dashboard}"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

# resource "aws_security_group_rule" "http_from_anywhere" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "TCP"
#   cidr_blocks       = ["${var.allow_cidr_block}"]
#   security_group_id = "${aws_security_group.alb.id}"
# }

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${var.instance_security_group_id}"
}

resource "aws_security_group_rule" "alb_to_http" {
  count                    = "${var.enable_privileged}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${var.instance_security_group_id}"
}

resource "aws_security_group_rule" "dashboard_to_http" {
  count                    = "${var.enable_dashboard}"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${var.instance_security_group_id}"
}

resource "aws_security_group_rule" "alb_to_https" {
  count                    = "${var.enable_privileged}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${var.instance_security_group_id}"
}
