output "certificate_arn" {
  value = "${aws_acm_certificate.cert.*.arn}"
}

output "dns_record" {
  value = "${aws_acm_certificate.cert.*.resource_record_name}"
}

output "dns_type" {
  value = "${aws_acm_certificate.cert.*.resource_record_type}"
}

output "dns_value" {
  value = "${aws_acm_certificate.cert.*.resource_record_value}"
}

