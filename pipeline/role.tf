resource "aws_iam_role" "default" {
  name = "${var.name}-pipeline"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy" "default" {
  name   = "codepipeline_policy"
  role   = "${aws_iam_role.default.id}"
  policy = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "CodePipelineAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "CodePipelineS3Policy"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}",
      "${aws_s3_bucket.default.arn}/*",
    ]
  }

  statement {
    sid    = "CodePipelineBuildPolicy"
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}
