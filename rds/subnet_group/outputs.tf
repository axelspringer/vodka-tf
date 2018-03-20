output "db_subnet_group_ids" {
  description = "The db subnet group ids"
  value       = "${aws_db_subnet_group.default.*.id}"
}

output "db_subnet_group_arns" {
  description = "The ARNs of the db subnet group"
  value       = "${aws_db_subnet_group.default.*.arn}"
}
