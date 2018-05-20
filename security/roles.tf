# + get resource IAM Role for Terraform admins
resource "aws_iam_role" "tf_admin" {
  name = "tf-${var.project}-${terraform.workspace}-admin"

  assume_role_policy = "${data.aws_iam_policy_document.tf_trust.json}"

  lifecycle {
    create_before_destroy = true
  }
}

# + get resource IAM Role for Terraform consumers
resource "aws_iam_role" "tf_consumer" {
  name = "tf-${var.project}-${terraform.workspace}-consumer"

  assume_role_policy = "${data.aws_iam_policy_document.tf_trust.json}"

  lifecycle {
    create_before_destroy = true
  }
}

# + get resource Attach IAM policy to Terraform admins
resource "aws_iam_policy_attachment" "tf_admin" {
  name       = "tf-${var.project}-${terraform.workspace}-admin"
  roles      = ["${aws_iam_role.tf_admin.name}"]
  policy_arn = "${aws_iam_policy.tf_admin.arn}"
}

# + get resource Attach IAM policy to Terraform consumer
resource "aws_iam_policy_attachment" "tf_consumer" {
  name       = "tf-${var.project}-${terraform.workspace}-consumer"
  roles      = ["${aws_iam_role.tf_consumer.name}"]
  policy_arn = "${aws_iam_policy.tf_consumer.arn}"
}

resource "aws_iam_role" "admin" {
  name               = "${var.project}-${terraform.workspace}-admin"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}

resource "aws_iam_role" "dev" {
  name               = "${var.project}-${terraform.workspace}-dev"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}

resource "aws_iam_role" "op" {
  name               = "${var.project}-${terraform.workspace}-op"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}

resource "aws_iam_role" "consumer" {
  name               = "${var.project}-${terraform.workspace}-consumer"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}
