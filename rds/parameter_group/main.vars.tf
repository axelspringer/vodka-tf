variable "create" {
  description = "Whether to create this resource or not?"
  default     = true
}

variable "branches" {
  description = "Git branches the parameter group should be created for"
  type        = "list"
}

variable "name" {
  description = "The name of the project to use for the parameter groups"
}

variable "family" {
  description = "The family of the DB parameter group"
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  default     = []
}

variable "tags" {
  type        = "map"
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
