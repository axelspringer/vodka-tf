# + get res DB instance
resource "aws_db_instance" "default" {
  count = "${length(var.branches)}"

  identifier = "${var.name}-${element(var.branches, count.index)}"

  engine            = "${var.engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${element(var.instance_class, count.index)}"
  allocated_storage = "${var.allocated_storage}"
  storage_type      = "${element(var.storage_type, count.index)}"
  storage_encrypted = "${var.storage_encrypted}"
  kms_key_id        = "${var.kms_key_id}"
  license_model     = "${var.license_model}"

  name                                = "${var.db_name}"
  username                            = "${var.username}"
  password                            = "${var.password}"
  port                                = "${var.port}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"

  replicate_source_db = "${var.replicate_source_db}"

  snapshot_identifier = "${var.snapshot_identifier}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name   = "${element(var.db_subnet_group_name, count.index)}"
  parameter_group_name   = "${element(var.parameter_group_name, count.index)}"

  availability_zone   = "${var.availability_zone}"
  multi_az            = "${element(var.multi_az, count.index)}"
  iops                = "${element(var.iops, count.index)}"
  publicly_accessible = "${var.publicly_accessible}"
  monitoring_interval = "${var.monitoring_interval}"
  monitoring_role_arn = "${element(aws_iam_role.default.*.arn, count.index)}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  final_snapshot_identifier   = "${var.name}-archive-${element(var.parameter_group_name, count.index)}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  tags = "${merge(var.tags, map("Name", "${var.name}-${element(var.branches, count.index)}"))}"

  depends_on = ["aws_iam_role.default"]
}
