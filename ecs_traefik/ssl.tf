# + get data AWS Certificate
data "aws_acm_certificate" "default" {
  count  = "${length(var.branches)}"
  domain = "*.${var.route53_wildcard_zone}"
}

data "aws_acm_certificate" "cert" {
  count  = "${length(var.domain_list)}"
  domain = "${element(var.domain_list, count.index)}"
}

