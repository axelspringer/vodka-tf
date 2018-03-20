# General
variable "branches" {
  description = "Git branches the parameter group should be created for"
  type        = "list"
}

variable "name" {
  description = "The name of the project to use for the parameter groups"
}

variable "tags" {
  type        = "map"
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

# VPC Subnets
variable "subnet_ids" {
  type = "list"
}
