variable "name" {
  description = "Name of the pipeline"
}

variable "cluster" {
  description = "ECS Cluster"
}

variable "org" {
  description = "Name of your organization"
}

variable "repo" {
  description = "Name of your repository"
}

variable "branch" {
  description = "Name of the branch to build"
}

variable "artifacts" {
  default = []
}