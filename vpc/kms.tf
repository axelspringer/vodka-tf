resource "aws_kms_key" "master" {
  description             = "${var.name}"
  deletion_window_in_days = "${var._kms_deletion_window_in_days}"
}

resource "aws_kms_alias" "master_alias" {
  name          = "alias/${var.name}"
  target_key_id = "${aws_kms_key.master.id}"
}
