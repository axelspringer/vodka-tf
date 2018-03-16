resource "aws_s3_bucket" "default" {
  count  = "${length(var.branches)}"
  bucket = "${var.cluster_name}-mango-pipeline-${element(var.branches, count.index)}"
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = true # with great power comes great responsibility
}
