# DB Parameter Groups
output "db_parameter_group_ids" {
  description = "The db parameter group ids"
  value       = "${module.parameter_group.db_parameter_group_ids}"
}

output "db_parameter_group_arns" {
  description = "The ARN of the db parameter groups"
  value       = "${module.parameter_group.db_parameter_group_arns}"
}

# DB Subnet Groups
output "db_subnet_group_ids" {
  description = "The db subnet group ids"
  value       = "${module.subnet_group.db_subnet_group_ids}"
}

output "db_subnet_group_arns" {
  description = "The ARNs of the db subnet group"
  value       = "${module.subnet_group.db_subnet_group_ids}"
}

# DB Monitoring
output "db_instance_role_arns" {
  description = "The ARNs of the db instance roles"
  value       = "${module.instance.db_instance_role_arns}"
}

# DB Roles
output "db_roles_arns" {
  description = "The ARNs of DB access roles"
  value       = "${aws_iam_role.default.*.arn}"
}

# DB Policies
output "db_policy_arns" {
  description = "The ARNS of the DB access policies by branch"
  value       = "${aws_iam_policy.default.*.arn}"
}

# DB Hosted Zones
output "db_instance_hosted_zone_ids" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)."
  value       = "${module.instance.db_instance_hosted_zone_ids}"
}
