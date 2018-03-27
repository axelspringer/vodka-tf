# + get res S3 Bucket to store pipeline things
resource "aws_s3_bucket" "default" {
  count  = "${length(var.branches)}"
  bucket = "${var.cluster_name}-mango-pipeline-${element(var.branches, count.index)}"
  acl    = "private"

  versioning {
    enabled = "${var._s3_versioning}"
  }

  force_destroy = true # with great power comes great responsibility
}

# + get res S3 Bucket to store static assets
resource "aws_s3_bucket" "static" {
  count  = "${length(var.branches)}"
  bucket = "${var.cluster_name}-mango-static-${element(var.branches, count.index)}"
  acl    = "public-read"

  lifecycle {
    prevent_destroy = true # Just for safety
  }
}

# + get res S3 Bucket Policy
resource "aws_s3_bucket_policy" "static" {
  count  = "${length(var.branches)}"
  bucket = "${element(aws_s3_bucket.static.*.id, count.index)}"
  policy = "${element(data.aws_iam_policy_document.static.*.json, count.index)}"
}

# + get res S3
data "aws_iam_policy_document" "static" {
  count = "${length(var.branches)}"

  statement {
    sid = "AllowECSTask"

    actions = [
      "s3:*",
    ]

    principals = {
      type = "AWS"

      identifiers = [
        "${element(aws_iam_role.task.*.arn, count.index)}",
      ]
    }

    resources = [
      "arn:aws:s3:::${var.cluster_name}-mango-static-${element(var.branches, count.index)}",
      "arn:aws:s3:::${var.cluster_name}-mango-static-${element(var.branches, count.index)}/*",
    ]
  }
}
