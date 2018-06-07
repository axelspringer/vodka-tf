output "iam_user_static_names" {
  value = "${aws_iam_user.static.*.name}"
}

output "aws_iam_access_key_ids" {
  value = "${aws_iam_access_key.static.*.id}"
}

output "aws_iam_access_key_secrets" {
  value = "${aws_iam_access_key.static.*.secret}"
}
