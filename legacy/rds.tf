# + get data Decrypt KMS encrypted database password
data "aws_kms_secret" "db" {
  secret {
    name    = "password"
    payload = "${var.rds_encrypted_password}" # passes in the KMS encrypted password

    context {
      project = "${var.rds_encrypted_password_context}" # this bound the context
    }
  }
}

# + get module RDS database instances, security etc.
module "db" {
  source = "../rds"

  # passes along the Git branches
  branches = "${var.branches}"

  name    = "${var.cluster_name}-legacy"
  db_name = "${var.rds_db_name}"

  # VPC
  vpc_id                    = "${var.vpc_id}"
  vpc_cidr_block            = "${var.vpc_cidr}"
  vpc_cidr_private_subnets  = "${var.vpc_cidr_private_subnets}"
  vpc_cidr_database_subnets = "${var.vpc_cidr_database_subnets}"
  vpc_cidr_vpn_subnets      = "${var.vpc_cidr_vpn_subnets}"      # should be remote state

  iam_database_authentication_enabled = "${var.rds_iam_database_authentication_enabled}"
  iam_user                            = "${var.rds_iam_user}"

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine            = "${var.rds_engine}"
  engine_version    = "${var.rds_engine_version}"
  instance_class    = ["${var.rds_instance_class}"]
  storage_type      = ["${var.rds_storage_type}"]
  iops              = ["${var.rds_iops}"]
  allocated_storage = "${var.rds_allocated_storage}"
  storage_encrypted = "${var.rds_storage_encrypted}"

  ecs_route53_zone_id = "${var.ecs_route53_zone_id}"

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  username               = "${var.rds_username}"
  password               = "${var.rds_encrypted_password != "" ? data.aws_kms_secret.db.password : var.rds_password}"
  port                   = "${var.rds_port}"
  vpc_security_group_ids = ["${var.rds_vpc_security_group_ids}"]
  maintenance_window     = "${var.rds_maintenance_window}"
  backup_window          = "${var.rds_backup_window}"
  multi_az               = ["${var.rds_multi_az}"]

  # disable backups to create DB faster
  backup_retention_period = "${var.rds_backup_retention_period}"

  # DB Parameter Groups
  family     = "${var.rds_family}"
  parameters = ["${var.rds_parameters}"]

  # Snapshot name upon DB deletion
  skip_final_snapshot = "${var.rds_skip_final_snapshot}"

  # DB Subnet Groups
  subnet_ids = ["${var.database_subnet_ids}"]
}
