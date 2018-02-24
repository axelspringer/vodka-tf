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
