variable "desired_capacity" {
  type = "list"
}

variable "branches" {
  type = "list"

  default = [
    "master",
    "develop",
  ]
}

variable "ecs_aws_ami" {}
variable "name" {}

variable "instance_type" {
  type = "list"
}

variable "max_size" {
  type = "list"
}

variable "min_size" {
  type = "list"
}

variable "vpc_id" {}
variable "key_name" {}

variable "private_subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

variable "_prefix" {
  default = ""
}
