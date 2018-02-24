variable "peer_vpc_ids" {
  description = "The Id of the peering VPC"
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
