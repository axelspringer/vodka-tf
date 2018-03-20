output "db_parameter_group_ids" {
  description = "The db parameter group ids"
  value       = "${aws_db_parameter_group.default.*.id}"
}

output "db_parameter_group_arns" {
  description = "The ARN of the db parameter groups"
  value       = "${aws_db_parameter_group.default.*.arn}"
}
