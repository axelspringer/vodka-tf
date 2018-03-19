output "alb_security_group_id" {
  value = "${aws_security_group.alb.id}"
}

output "default_alb_target_groups" {
  value = "${aws_alb_target_group.default.*.arn}"
}

output "default_alb_zone_ids" {
  value = "${aws_alb.alb.*.zone_id}"
}

output "default_alb_dns_names" {
  value = "${aws_alb.alb.*.dns_name}"
}
