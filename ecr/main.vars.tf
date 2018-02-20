variable "name" { }
variable "stage" { }

variable "roles" {
  type        = "list"
  description = "Principal IAM roles to provide with access to the ECR"
  default     = []
}

variable "groups" {
  type        = "list"
  description = "Groups to provide with access to the ECR"
  default     = []
}

variable "tags" {
  type    = "map"
  default = { }
}

variable "max_image_count" {
  type        = "string"
  description = "How many Docker Image versions AWS ECR will store"
  default     = "7"
}
