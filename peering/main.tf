resource "aws_vpc_peering_connection" "default" {
  count         = "${length(var.peer_vpc_ids)}"

  peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id   = "${element(var.peer_vpc_ids, count.index)}"

  vpc_id        = "${var.vpc_id}"
  auto_accept   = "${var._auto_accept}"

  accepter {
    allow_remote_vpc_dns_resolution = "${var._allow_remote_vpc_dns_resolution}"
  }

  requester {
    allow_remote_vpc_dns_resolution = "${var._allow_remote_vpc_dns_resolution}"
  }

  tags = "${ merge( var.tags, map( "Terraform", "true" ) ) }"
}

resource "aws_route" "peer_from_to_peer_to" {
  count = "${length(var.peer_from_route_tables)}"

  route_table_id            = "${element(var.peer_from_route_tables, count.index)}"
  destination_cidr_block    = "${var.destination_from_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.default.id}"
}

resource "aws_route" "peer_to_to_peer_from" {
  count = "${length(var.peer_to_route_tables)}"

  route_table_id            = "${element(var.peer_to_route_tables, count.index)}"
  destination_cidr_block    = "${var.destination_to_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.default.id}"
}
