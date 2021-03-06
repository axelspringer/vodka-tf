output "admins_id" {
  value       = "${aws_iam_group.admins.id}"
  description = "The group's ID."
}

output "admins_name" {
  value       = "${aws_iam_group.admins.name}"
  description = "The group's name."
}

output "admins_arn" {
  value       = "${aws_iam_group.admins.arn}"
  description = "The ARN assigned by AWS for this group."
}

output "devs_id" {
  value       = "${aws_iam_group.devs.id}"
  description = "The group's ID."
}

output "devs_name" {
  value       = "${aws_iam_group.devs.name}"
  description = "The group's name."
}

output "devs_arn" {
  value       = "${aws_iam_group.devs.arn}"
  description = "The ARN assigned by AWS for this group."
}

output "ops_id" {
  value       = "${aws_iam_group.devs.id}"
  description = "The group's ID."
}

output "ops_name" {
  value       = "${aws_iam_group.devs.name}"
  description = "The group's name."
}

output "ops_arn" {
  value       = "${aws_iam_group.devs.arn}"
  description = "The ARN assigned by AWS for this group."
}
