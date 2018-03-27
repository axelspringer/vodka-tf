# + get res Route53 RDS discovery zone records
resource "aws_route53_record" "discovery" {
  count = "${length(var.enable_ecs_discovery) ? length(var.branches) : 0}"

  zone_id = "${data.aws_route53_zone.discovery.zone_id}"
  name    = "$.db.${data.aws_route53_zone.discovery.name}"
  type    = "CNAME"
  ttl     = "0"
  records = ["${element(module.instance.db_instance_hosted_zone_ids, count.index)}"]
}

# + get data Route53 discovery zone
data "aws_route53_zone" "discovery" {
  zone_id = "${var.ecs_route53_zone_id}"
}
