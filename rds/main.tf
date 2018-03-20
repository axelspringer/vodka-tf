data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  current = true
}

# + get module DB Parameter Groups
module "parameter_group" {
  source = "./parameter_group"

  name     = "${var.name}"
  family   = "${var.family}"
  branches = "${var.branches}"

  parameters = ["${var.parameters}"]

  tags = "${var.tags}"
}

# + get module DB Subnet Groups
module "subnet_group" {
  source = "./subnet_group"

  name     = "${var.name}"
  branches = "${var.branches}"

  subnet_ids = "${var.subnet_ids}"

  tags = "${var.tags}"
}

# + get module DB Instances
module "instance" {
  source = "./instance"

  name     = "${var.name}"
  branches = "${var.branches}"

  vpc_id                    = "${var.vpc_id}"
  vpc_cidr_block            = "${var.vpc_cidr_block}"
  vpc_cidr_private_subnets  = "${var.vpc_cidr_private_subnets}"
  vpc_cidr_database_subnets = "${var.vpc_cidr_database_subnets}"
  vpc_cidr_vpn_subnets      = "${var.vpc_cidr_vpn_subnets}"

  db_name           = "${var.db_name}"
  engine            = "${var.engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_type      = "${var.storage_type}"
  storage_encrypted = "${var.storage_encrypted}"
  kms_key_id        = "${var.kms_key_id}"
  license_model     = "${var.license_model}"

  name                                = "${var.name}"
  username                            = "${var.username}"
  password                            = "${var.password}"
  port                                = "${var.port}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"

  replicate_source_db = "${var.replicate_source_db}"

  snapshot_identifier = "${var.snapshot_identifier}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  db_subnet_group_name   = ["${module.subnet_group.db_subnet_group_ids}"]
  parameter_group_name   = ["${module.parameter_group.db_parameter_group_ids}"]

  availability_zone   = "${var.availability_zone}"
  multi_az            = "${var.multi_az}"
  iops                = "${var.iops}"
  publicly_accessible = "${var.publicly_accessible}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  monitoring_interval = "${var.monitoring_interval}"

  tags = "${var.tags}"
}
