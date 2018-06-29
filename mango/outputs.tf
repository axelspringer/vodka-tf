output "iam_user_static_names" {
  value = "${aws_iam_user.static.*.name}"
}

output "aws_iam_access_key_ids" {
  value = "${aws_iam_access_key.static.*.id}"
}

output "aws_iam_access_key_secrets" {
  value = "${aws_iam_access_key.static.*.secret}"
}

output "aws_ses_user_names" {
  value = "${aws_iam_user.email.*.name}"
}

output "aws_ses_access_key_ids" {
  value = "${aws_iam_access_key.email.*.id}"
}

output "aws_ses_access_key_secrets" {
  value = "${aws_iam_access_key.email.*.secret}"
}
