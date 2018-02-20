output "admins_id" {
  value       = "${aws_iam_group.admins.id}"
  description = "The group's ID."
}

output "admins_uuid" {
  value       = "${aws_iam_group.admins.unique_id}"
  description = "The unique ID assigned by AWS."
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

output "devs_uuid" {
  value       = "${aws_iam_group.devs.unique_id}"
  description = "The unique ID assigned by AWS."
}

output "devs_name" {
  value       = "${aws_iam_group.devs.name}"
  description = "The group's name."
}

output "devs_arn" {
  value       = "${aws_iam_group.devs.arn}"
  description = "The ARN assigned by AWS for this group."
}