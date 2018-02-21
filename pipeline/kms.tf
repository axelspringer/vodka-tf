resource "aws_kms_key" "s3key" {
  description             = "${var.name}-pipeline"
  deletion_window_in_days = 10
}
