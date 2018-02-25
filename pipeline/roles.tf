resource "aws_iam_role" "pipeline" {
  name = "${var.name}-pipeline"

  assume_role_policy = "${data.aws_iam_policy_document.pipeline_role.json}"
}

resource "aws_iam_role" "build" {
  name = "${var.name}-build"

  assume_role_policy = "${data.aws_iam_policy_document.build_role.json}"
}

resource "aws_iam_role" "ecr" {
  name               = "${var.name}-ecr"
  assume_role_policy = "${data.aws_iam_policy_document.ecr_role.json}"
}

resource "aws_iam_role_policy_attachment" "pipeline" {
  role       = "${aws_iam_role.pipeline.id}"
  policy_arn = "${aws_iam_policy.pipeline.arn}"
}

resource "aws_iam_role_policy_attachment" "build" {
  role       = "${aws_iam_role.build.id}"
  policy_arn = "${aws_iam_policy.build.arn}"
}

resource "aws_iam_role_policy_attachment" "ecr_default" {
  role       = "${aws_iam_role.ecr.name}"
  policy_arn = "${aws_iam_policy.ecr.arn}"
}

resource "aws_iam_policy" "pipeline" {
  name        = "${var.name}-pipeline"
  description = "A test policy"
  policy      = "${data.aws_iam_policy_document.pipeline_policy.json}"
}

resource "aws_iam_policy" "build" {
  name        = "${var.name}-build"
  description = "A test policy"
  path        = "/service-role/"
  policy      = "${data.aws_iam_policy_document.build_policy.json}"
}

resource "aws_iam_policy" "ecr" {
  name        = "${var.name}-ecr"
  description = "Allow IAM Users to call ecr:GetAuthorizationToken"
  policy      = "${data.aws_iam_policy_document.ecr_token.json}"
}

resource "aws_iam_group_policy_attachment" "default" {
  count      = "${length(var.ecr_groups)}"
  group      = "${element(var.ecr_groups, count.index)}"
  policy_arn = "${aws_iam_policy.ecr.arn}"
}

data "aws_iam_policy_document" "pipeline_role" {
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

data "aws_iam_policy_document" "ecr_role" {
  statement {
    sid     = "EC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr_token" {
  statement {
    sid     = "ECRGetAuthorizationToken"
    effect  = "Allow"
    actions = ["ecr:GetAuthorizationToken"]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "build_role" {
  statement {
    sid     = "CodeBuildAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "default_ecr" {
  statement {
    sid    = "ecr"
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${aws_iam_role.ecr.arn}",
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]
  }
}

data "aws_iam_policy_document" "build_policy" {
  statement {
    sid    = "CodeBuildPolicy"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "CodeBuildS3Policy"
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "${concat(aws_s3_bucket.default.*.arn, formatlist("%v/*", aws_s3_bucket.default.*.arn))}",
    ]
  }

  statement {
    sid    = "CodeBuildKMSPolicy"
    effect = "Allow"

    actions = [
      "kms:*",
    ]

    resources = ["${aws_kms_key.s3key.*.arn}"]
  }

  statement {
    sid    = "CodeBuildECRPolicy"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]

    resources = [
      "${aws_ecr_repository.default.*.arn}",
    ]
  }
}

data "aws_iam_policy_document" "pipeline_policy" {
  statement {
    sid    = "CodePipelineS3Policy"
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "${concat(aws_s3_bucket.default.*.arn, formatlist("%v/*", aws_s3_bucket.default.*.arn))}",
    ]
  }

  statement {
    sid    = "CodePipelineBuildPolicy"
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StopBuild",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CodePipelineKMSPolicy"
    effect = "Allow"

    actions = [
      "kms:*",
    ]

    resources = ["${aws_kms_key.s3key.*.arn}"]
  }
}
