variable "desired_capacity" { }
variable "ecs_aws_ami"      { }
variable "environment"      { }
variable "instance_type"    { }
variable "max_size"         { }
variable "min_size"         { }
variable "vpc_cidr"         { }
variable "key_name"         { }

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}