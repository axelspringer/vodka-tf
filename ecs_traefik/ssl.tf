# + get data AWS Certificate
data "aws_acm_certificate" "default" {
  count  = "${length(var.branches)}"
  domain = "*.${element(var.branches, count.index)}.${var.route53_wildcard_zone}"
}
