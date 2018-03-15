output "discovery_zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}

output "discovery_servers" {
  value = "${aws_route53_zone.default.name_servers}"
}
