variable "cluster_ids" {
  type        = "list"
  description = "ECS Cluster id"
}

variable "branches" {
  type = "list"

  default = [
    "master",
    "develop",
  ]
}

variable "cluster_name" {
  description = "ECS Cluster name"
}

variable "instance_security_group_id" {}

variable "vpc_id" {
  description = "VPC id"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "VPC public subnets"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "VPC privare subnets"
}

variable "github_org" {
  description = "Name of your organization"
}

variable "github_repo" {
  description = "Name of your repository"
}

variable "github_branches" {
  default = [
    "master",
    "develop",
  ]

  description = "The branches to be build"
}

variable "kms_master_key_arn" {
  description = "The KMS master key for encryption"
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

variable "deploy_functions" {
  type        = "list"
  description = "deploy"
}

variable "build_compute_type" {
  default = "BUILD_GENERAL1_MEDIUM"
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

# variable "dns_namespace" {
#   description = "DNS Namespace for autodiscovery"
# }

variable "dns_description" {
  default     = ""
  description = "DNS Description for autodiscovery"
}

variable "size" {
  default     = 1
  description = "The number of instances of the task definition to place and keep running"
}

variable "placement_strategy_type" {
  default     = "binpack"
  description = "The type of placement strategy. Must be one of: binpack, random, or spread"
}

variable "placement_strategy_field" {
  default = "cpu"
}

variable "placement_constraint_type" {
  default     = "memberOf"
  description = "The type of constraint. The only valid values at this time are memberOf and distinctInstance."
}

variable "placement_constraint_expression" {
  default     = "attribute:ecs.availability-zone in [eu-west-1c, eu-west-1a]"
  description = "luster Query Language expression to apply to the constraint. Does not need to be specified for the distinctInstance type."
}

variable "cpu" {
  default     = 128
  description = "The CPU limit for this container definition"
}

variable "memory" {
  default     = 128
  description = "The memory limit for this container definition"
}

variable "memory_reservation" {
  default     = 64
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit"
}

variable "environment" {
  default     = []
  description = "The environment in use"
}

variable "disable_networking" {
  default     = false
  description = "Indicator if networking is disabled"
}

variable "docker_labels" {
  default     = {}
  type        = "map"
  description = "Set docker labels"
}

# ! private
variable "_image" {
  default = "axelspringer/nginx"
}

variable "_container_port" {
  default = 8080
}

variable "_build_privileged_mode" {
  default = true
}

variable "_build_timeout" {
  default = "20"
}
