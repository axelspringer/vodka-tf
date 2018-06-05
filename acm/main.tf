# + request certificates for list of domains
resource "aws_acm_certificate" "cert" {
	count = "${length(var.domain_list)}"
  domain_name = "${element(var.domain_list, count.index)}"
  validation_method = "DNS"
}
