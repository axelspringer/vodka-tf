#--------------------------------------------------------------
# Recipe
# 
# + get res group
#--------------------------------------------------------------

resource "aws_iam_group" "admins" {
  name = "${var.name}-${terraform.workspace}-admins"
}

resource "aws_iam_group" "devs" {
  name = "${var.name}-${terraform.workspace}-devs"
}