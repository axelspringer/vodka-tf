#--------------------------------------------------------------
# Recipe
#
# + get res group
#--------------------------------------------------------------

# + get res IAM Group for project admins
resource "aws_iam_group" "admins" {
  name = "${var.name}-${terraform.workspace}-admins"
}

# + get res IAM Group for project devs
resource "aws_iam_group" "devs" {
  name = "${var.name}-${terraform.workspace}-devs"
}

# + get res IAM Group for project operations
resource "aws_iam_group" "ops" {
  name = "${var.name}-${terraform.workspace}-ops"
}
