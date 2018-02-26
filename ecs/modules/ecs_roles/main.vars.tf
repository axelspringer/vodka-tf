variable "cluster" {
  description = "The name of the ECS cluster"
}

variable "branches" {
  type        = "list"
  description = "The branches to be used in the clusters"
}

variable "prefix" {
  default     = ""
  description = "The prefix of the parameters this role should be able to access"
}
