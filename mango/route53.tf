# + get res AWS Route 53 alias record for Gateway
resource "aws_route53_record" "gw" {
  count   = "${length(var.branches)}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  name    = "${var.cluster_name}-mango-gw-${element(var.branches, count.index)}"
  type    = "A"

  alias {
    name                   = "${element(module.alb_gw.default_alb_dns_names, count.index)}"
    zone_id                = "${element(module.alb_gw.default_alb_zone_ids, count.index)}"
    evaluate_target_health = "${var._evaluate_target_health}"
  }
}

# + get res AWS Route 53 alias record for SSR
resource "aws_route53_record" "ssr" {
  count   = "${length(var.branches)}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  name    = "${var.cluster_name}-mango-ssr-${element(var.branches, count.index)}"
  type    = "A"

  alias {
    name                   = "${element(module.alb_ssr.default_alb_dns_names, count.index)}"
    zone_id                = "${element(module.alb_ssr.default_alb_zone_ids, count.index)}"
    evaluate_target_health = "${var._evaluate_target_health}"
  }
}

# + get res AWS Route 53 alias record for WP
resource "aws_route53_record" "wp" {
  count   = "${length(var.branches)}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  name    = "${var.cluster_name}-mango-wp-${element(var.branches, count.index)}"
  type    = "A"

  alias {
    name                   = "${element(module.alb_wp.default_alb_dns_names, count.index)}"
    zone_id                = "${element(module.alb_wp.default_alb_zone_ids, count.index)}"
    evaluate_target_health = "${var._evaluate_target_health}"
  }
}

# + get data AWS Route 53 zone to be used for external use
data "aws_route53_zone" "default" {
  name = "${var.route53_zone}"
}
