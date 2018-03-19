# + get resource IAM Group for Terraform admin
resource "aws_iam_group" "tf_admins" {
  name = "${var.project}-${terraform.workspace}-tf-admins"
  path = "/users/"
}

# + get resource IAM Group for Terraform consumer
resource "aws_iam_group" "tf_consumers" {
  name = "${var.project}-${terraform.workspace}-tf-consumers"
  path = "/users/"
}

# + get resource IAM Group for admins
resource "aws_iam_group" "admins" {
  name = "${var.project}-${terraform.workspace}-admins"
  path = "/users/"
}

# + get resource IAM Group for Consumers
resource "aws_iam_group" "devs" {
  name = "${var.project}-${terraform.workspace}-devs"
  path = "/users/"
}

# + get resource IAM Group for DevOps
resource "aws_iam_group" "ops" {
  name = "${var.project}-${terraform.workspace}-ops"
  path = "/users/"
}

# + get resource IAM Group for Consumers
resource "aws_iam_group" "consumers" {
  name = "${var.project}-${terraform.workspace}-consumers"
  path = "/users/"
}
