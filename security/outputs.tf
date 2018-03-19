# + output IAM Role Arn for Terraform admin
output "tf_admin_role_arn" {
  value = "${aws_iam_role.tf_admin.arn}"
}

# + output IAM Role Arn for Terraform admin
output "tf_admin_role_id" {
  value = "${aws_iam_role.tf_admin.id}"
}

# + output IAM Role Arn for Terraform consumer
output "tf_consumer_role_arn" {
  value = "${aws_iam_role.tf_consumer.arn}"
}

# + output IAM Role Arn for Terraform consumer
output "tf_consumer_role_id" {
  value = "${aws_iam_role.tf_consumer.id}"
}

# + output IAM Group for Terraform admins
output "tf_admins_group_arn" {
  value = "${aws_iam_group.tf_admins.arn}"
}

# + output IAM Group for Terraform admins
output "tf_admins_group_id" {
  value = "${aws_iam_group.tf_admins.id}"
}

# + output IAM Group for Terraform consumer
output "tf_consumers_group_arn" {
  value = "${aws_iam_group.tf_consumers.arn}"
}

# + output IAM Group for Terraform consumer
output "tf_consumers_group_id" {
  value = "${aws_iam_group.tf_consumers.id}"
}

# + output IAM Group for ops
output "ops_group_arn" {
  value = "${aws_iam_group.ops.arn}"
}

# + output IAM Group for ops
output "ops_group_id" {
  value = "${aws_iam_group.ops.id}"
}

# + output IAM Group for admins
output "admins_group_arn" {
  value = "${aws_iam_group.admins.arn}"
}

# + output IAM Group for admins
output "admins_group_id" {
  value = "${aws_iam_group.admins.id}"
}

# + output IAM Group for consumers
output "consumers_group_arn" {
  value = "${aws_iam_group.consumers.arn}"
}

# + output IAM Group for consumers
output "consumers_group_id" {
  value = "${aws_iam_group.consumers.id}"
}

# + output IAM Group for devs
output "devs_group_arn" {
  value = "${aws_iam_group.devs.arn}"
}

# + output IAM Group for devs
output "devs_group_id" {
  value = "${aws_iam_group.devs.id}"
}
