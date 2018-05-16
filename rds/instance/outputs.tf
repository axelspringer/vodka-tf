output "db_instance_ids" {
  description = "The DB instance ids"
  value       = "${aws_db_instance.default.*.id}"
}

output "db_instance_endpoint" {
  value 			= "${aws_db_instance.default.*.endpoint}"
}

output "db_instance_resource_id" {
  description = "The DB instance ids"
  value       = "${aws_db_instance.default.*.resource_id}"
}

output "db_instance_role_arns" {
  description = "The ARNs of the db instance roles"
  value       = "${aws_iam_role.default.*.arn}"
}

output "db_instance_hosted_zone_ids" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)."
  value       = "${aws_db_instance.default.*.hosted_zone_id}"
}
