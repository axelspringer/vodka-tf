variable "cluster_id" {
  description = "ECS Cluster id"
}

variable "cluster_name" {
  description = "ECS Cluster name"
}

variable "size" {
  default     = 2
  description = "The number of instances of the task definition to place and keep running"
}

variable "alb_target_group" {
  description = "The ARN of the ALB target group to associate with the service"
}

variable "placement_strategy_type" {
  default     = "binpack"
  description = "The type of placement strategy. Must be one of: binpack, random, or spread"
}

variable "placement_strategy_field" {
  default     = "cpu"
}

variable "placement_constraint_type" {
  default     = "memberOf"
  description = "The type of constraint. The only valid values at this time are memberOf and distinctInstance."
}

variable "placement_constraint_expression" {
  default     = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b]"
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
  default     = { }
  type        = "map"
  description = "Set docker labels"
}
