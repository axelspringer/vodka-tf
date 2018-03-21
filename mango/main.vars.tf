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

variable "project" {
  description = "Project id that is used for Mango"
}

variable "route53_zone" {
  default     = "tortuga.services"
  description = "Route 53 Zone to use for external use"
}

variable "cluster_name" {
  description = "ECS Cluster name"
}

variable "instance_security_group_id" {}

variable "vpc_id" {
  description = "VPC id"
}

variable "vpc_cidr" {
  description = "VPC cidr port to allow traffic from and to"
}

variable "vpc_cidr_private_subnets" {
  description = "Cidr blocks for the private subnets to allow traffic from and to"
  type        = "list"
}

variable "vpc_cidr_database_subnets" {
  description = "Cidr blocks for the database subnets to allow traffic from and to"
  type        = "list"
}

variable "vpc_cidr_vpn_subnets" {
  description = "Cidr blocks for the database subnets to allow traffic from and to"
  type        = "list"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "VPC public subnets"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "VPC privare subnets"
}

variable "database_subnet_ids" {
  type        = "list"
  description = "VPC privare subnets"
}

variable "vpn_subnet_ids" {
  description = "Cidr blocks for the database subnets to allow traffic from and to"
  type        = "list"
  default     = []
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

# DB Name
variable "rds_db_name" {
  description = "The database name to be used across service"
}

# DB Subnet Groups
variable "rds_family" {
  description = "The family of the DB parameter group"
}

variable "rds_parameters" {
  description = "The parameters for the DB parameters group"
  type        = "list"
  default     = []
}

# DB Instances
variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
}

variable "rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = "list"
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
}

variable "rds_replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  default     = ""
}

variable "rds_snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  default     = ""
}

variable "rds_license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  default     = ""
}

variable "rds_iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

variable "rds_iam_user" {
  description = "RDS IAM user in MySQL"
  default     = "rds_user"
}

variable "rds_engine" {
  description = "The database engine to use"
}

variable "rds_engine_version" {
  description = "The engine version to use"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = "list"
}

variable "rds_username" {
  description = "Username for the master DB user"
}

variable "rds_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
}

variable "rds_encrypted_password" {
  description = "KMS encrypted password for the user"
  default     = ""
}

variable "rds_port" {
  description = "The port on which the DB accepts connections"
}

variable "rds_copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = false
}

variable "rds_vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  default     = []
}

variable "rds_availability_zone" {
  description = "The Availability Zone of the RDS instance"
  default     = ""
}

variable "rds_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = "list"
}

variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = "list"
}

variable "rds_publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  default     = 5
}

variable "rds_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  default     = false
}

variable "rds_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = true
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  default     = 1
}

variable "rds_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
}

# ! private
variable "_image" {
  default = "axelspringer/nginx"
}

variable "_evaluate_target_health" {
  default = true
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
