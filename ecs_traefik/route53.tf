# + get date Route 53 of the host zone
data "aws_route53_zone" "default" {
  name = "${var.route53_zone}"
}

# + get res Route 53 of the wildcard domain
resource "aws_route53_record" "default" {
  count   = "${length(var.branches)}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  name    = "${join(".", list("*", element(var.branches, count.index), var.cluster_name, data.aws_route53_zone.default.name ))}"
  type    = "A"

  alias {
    name                   = "${element(module.alb.default_alb_dns_names, count.index)}"
    zone_id                = "${element(module.alb.default_alb_zone_ids, count.index)}"
    evaluate_target_health = "${var._evaluate_target_health}"
  }
}
