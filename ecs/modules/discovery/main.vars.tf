variable "name" {}

variable "vpc_id" {}
variable "comment" {}

variable "tags" {
  type    = "map"
  default = {}
}

variable "_private_zone" {
  default = true
}
