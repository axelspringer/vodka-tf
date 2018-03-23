variable "name" {
  default     = "default"
  description = "The name of the loadbalancer"
}

variable "instance_security_group_id" {}

variable "branches" {
  type = "list"
}

variable "enable_privileged" {
  description = "Enable privileged ports to be routed"
  default     = false
}

variable "enable_dashboard" {
  description = "Enable dashboard ports to be routed"
  default     = false
}

variable "cluster" {
  default     = "default"
  description = "The cluster to load balance"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "List of public subnet ids to place the loadbalancer in"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cird block that is allowd to acces the LoadBalancer"
}

variable "_enable_http2" {
  default = true
}

variable "tags" {
  type    = "map"
  default = {}
}
