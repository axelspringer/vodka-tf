variable "desired_capacity"   { }
variable "ecs_aws_ami"        { }
variable "name"               { }
variable "instance_type"      { }
variable "max_size"           { }
variable "min_size"           { }
variable "vpc_id"             { }
variable "key_name"           { }

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
