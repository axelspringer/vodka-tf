# + get data AWS Certificate
data "aws_acm_certificate" "default" {
  count  = "${length(var.branches)}"
  domain = "*.${var.route53_zone}"
}
