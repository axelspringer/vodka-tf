variable "name" {
  description = "Name of the pipeline"
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

variable "ecr_max_image_count" {
  type        = "string"
  description = "How many Docker Image versions AWS ECR will store"
  default     = "7"
}

variable "ecs_availability_zones" {
  type        = "list"
  description = "Zones the ECS should run in"
}

variable "ecs_vpc_id" {
  description = "VPC to use"
}

variable "ecs_ami" {
  default     = "ami-880d64f1"                 # Add mapping to region
  description = "AMI to use for the instances"
}

variable "ecs_instance_key_name" {
  description = "SSH Key for the instance"
}

variable "ecs_instance_type" {
  type        = "list"
  description = "Instance types to use for the branch clusters"
}

variable "ecs_esired_capacity" {
  type        = "list"
  description = "Desired capacity of the branch in the cluster"
}

variable "ecs_max_size" {
  type        = "list"
  description = "Max size of the branch clusters"
}

variable "ecs_min_size" {
  type        = "list"
  description = "Min size of the branch clusters"
}

variable "ecs_private_subnet_ids" {
  type        = "list"
  description = "Private subnet ids to draw from"
}

variable "ecs_public_subnet_ids" {
  type        = "list"
  description = "Public subnet ids to draw from"
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
