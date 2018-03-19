# + output IAM Role Arn for Terraform admin
output "tf_admin_role_arn" {
  value = "${aws_iam_role.tf_admin.arn}"
}

# + output IAM Role Arn for Terraform consumer
output "tf_consumer_role_arn" {
  value = "${aws_iam_role.tf_consumer.arn}"
}

# + output IAM Group for Terraform admins
output "tf_admins_group_arn" {
  value = "${aws_iam_group.tf_admins.arn}"
}

# + output IAM Group for Terraform consumer
output "tf_consumers_group_arn" {
  value = "${aws_iam_group.tf_consumers.arn}"
}

# + output IAM Group for ops
output "ops_group_arn" {
  value = "${aws_iam_group.ops.arn}"
}

# + output IAM Group for admins
output "admins_group_arn" {
  value = "${aws_iam_group.admins.arn}"
}

# + output IAM Group for consumers
output "consumers_group_arn" {
  value = "${aws_iam_group.consumers.arn}"
}
