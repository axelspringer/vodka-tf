resource "aws_route53_zone" "default" {
  name = "${var.name}"

  vpc_id  = "${var.vpc_id}"
  comment = "${var.comment}"

  tags = "${ merge( var.tags, map( "Name", var.name ), map( "Terraform", "true" ) ) }"
}
