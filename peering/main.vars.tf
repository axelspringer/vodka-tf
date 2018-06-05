variable "peer_vpc_ids" {
  description = "The Id of the peering VPC"

	type = "list"
}

variable "peer_owner_id" {
  description = "The Id of the owner of the requesting VPC"
}

variable "vpc_id" {
  description = "The Id of the requested VPC"
}

variable "tags" {
  default = {}
  type    = "map"
}

# ! Private
variable "_allow_remote_vpc_dns_resolution" {
  default = true
}

variable "_auto_accept" {
  default = true
}

variable "peer_from_route_tables" {
  type = "list"

  description = "List of route tables from the peer_from VPC"
}

variable "peer_to_route_tables" {
  type = "list"

  description = "List of route tables from the peer to VPC."
}

variable "destination_from_cidr" {
	description = ""
}

variable "destination_to_cidr" {
	description = ""
}
