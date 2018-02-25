variable "name" {
  description = "Name of the pipeline"
}

variable "ecs_cluster" {
  description = "ECS Cluster"
}

variable "ecs_service" {
  description = "Service in the ECS cluster"
}

variable "org" {
  description = "Name of your organization"
}

variable "repo" {
  description = "Name of your repository"
}

variable "branches" {
  default = [
    "master",
    "develop",
  ]

  description = "The branches to be build"
}

variable "ecr_roles" {
  type        = "list"
  description = "Principal IAM roles to provide with access to the ECR"
  default     = []
}

variable "ecr_groups" {
  type        = "list"
  description = "Groups to provide with access to the ECR"
  default     = []
}

variable "max_image_count" {
  type        = "string"
  description = "How many Docker Image versions AWS ECR will store"
  default     = "7"
}

variable "build_compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
  default = "aws/codebuild/nodejs:6.3.1"
}

variable "build_type" {
  default = "LINUX_CONTAINER"
}

variable "tags" {
  type    = "map"
  default = {}
}
