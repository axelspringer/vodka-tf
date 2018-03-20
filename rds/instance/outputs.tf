output "db_instance_ids" {
  description = "The DB instance ids"
  value       = "${aws_db_instance.default.*.id}"
}

output "db_instance_resource_id" {
  description = "The DB instance ids"
  value       = "${aws_db_instance.default.*.resource_id}"
}

output "db_instance_role_arns" {
  description = "The ARNs of the db instance roles"
  value       = "${aws_iam_role.default.*.arn}"
}
