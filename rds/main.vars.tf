# General
variable "name" {
  description = "Name to use for the DB resources"
}

variable "branches" {
  type        = "list"
  description = "Git branches to create DB resources"

  default = [
    "master",
    "develop",
  ]
}

variable "vpc_id" {
  description = "VPC in which the databases are running"
}

variable "vpc_cidr_block" {
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

variable "tags" {
  description = "A mapping of tags to assign to all DB resources"
  default     = {}
}

variable "enable_ecs_discovery" {
  default = true
}

variable "ecs_route53_zone_id" {
  description = "Route53 Zone to use for db instance CNAMES"
}

# DB Subnet Groups
variable "family" {
  description = "The family of the DB parameter group"
}

variable "parameters" {
  description = "The parameters for the DB parameters group"
  type        = "list"
  default     = []
}

# DB Subnet Groups
variable "subnet_ids" {
  type        = "list"
  description = "The ids of the VPC subnets to use"
}

# DB Instances
variable "db_name" {
  description = "The database name to be used"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = "list"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  default     = ""
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  default     = ""
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  default     = ""
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

variable "iam_user" {
  description = "RDS IAM user in MySQL"
  default     = "rds_user"
}

variable "engine" {
  description = "The database engine to use"
}

variable "engine_version" {
  description = "The engine version to use"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = "list"
}

variable "username" {
  description = "Username for the master DB user"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
}

variable "port" {
  description = "The port on which the DB accepts connections"
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  default     = []
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = "list"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = "list"
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  default     = 5
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  default     = 1
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
}
