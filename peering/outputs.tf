output "peering_ids" {
  value = "${aws_vpc_peering_connection.default.*.id}"
}

output "peering_accept_status" {
  value = "${aws_vpc_peering_connection.default.*.accept_status}"
}
