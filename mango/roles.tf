data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "pipeline" {
  name = "${var.cluster_name}-mango-pipeline"

  assume_role_policy = "${data.aws_iam_policy_document.pipeline_role.json}"
}

resource "aws_iam_role" "build" {
  name = "${var.cluster_name}-mango-build"

  assume_role_policy = "${data.aws_iam_policy_document.build_role.json}"
}

resource "aws_iam_role" "ecr" {
  name               = "${var.cluster_name}-mango-ecr"
  assume_role_policy = "${data.aws_iam_policy_document.ecr_role.json}"
}

resource "aws_iam_role" "task" {
  count              = "${length(var.branches)}"
  name               = "${var.cluster_name}-task-${element(var.branches, count.index)}-mango"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
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

resource "aws_iam_role_policy_attachment" "task" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.task.*.name, count.index)}"
  policy_arn = "${element(aws_iam_policy.task.*.arn, count.index)}"
}

resource "aws_iam_role_policy_attachment" "rds" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.task.*.name, count.index)}"
  policy_arn = "${element(module.db.db_policy_arns, count.index)}"
}

resource "aws_iam_group_policy_attachment" "default" {
  count      = "${length(var.ecr_groups)}"
  group      = "${element(var.ecr_groups, count.index)}"
  policy_arn = "${aws_iam_policy.ecr.arn}"
}

resource "aws_iam_policy" "pipeline" {
  name        = "${var.cluster_name}-mango-pipeline"
  description = "A test policy"
  policy      = "${data.aws_iam_policy_document.pipeline_policy.json}"
}

resource "aws_iam_policy" "build" {
  name        = "${var.cluster_name}-mango-build"
  description = "A test policy"
  path        = "/service-role/"
  policy      = "${data.aws_iam_policy_document.build_policy.json}"
}

resource "aws_iam_policy" "ecr" {
  name        = "${var.cluster_name}-mango-ecr"
  description = "Allow IAM Users to call ecr:GetAuthorizationToken"
  policy      = "${data.aws_iam_policy_document.ecr_token.json}"
}

resource "aws_iam_policy" "task" {
  count       = "${length(var.branches)}"
  name        = "${var.cluster_name}-${element(var.branches, count.index)}-task-mango"
  description = "Allow ECS task to call AWS APIs"
  policy      = "${element(data.aws_iam_policy_document.task_policy.*.json, count.index)}"
}

data "aws_iam_policy_document" "task_role" {
  statement {
    sid     = "ECSTaskRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
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
    sid    = "CodeBuildAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "task_policy" {
  count = "${length(var.branches)}"

  statement {
    sid    = "ECSTaskPolicyKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = ["${var.kms_master_key_arn}"]
  }

  statement {
    sid    = "ECSTaskPolicy"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.cluster_name}-${element(var.branches, count.index)}/*",
    ]
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
    sid    = "CodeDeployPolicy"
    effect = "Allow"

    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]

    resources = ["*"]
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

    resources = ["${var.kms_master_key_arn}"]
  }

  statement {
    sid    = "CodeBuildECRPolicy"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]

    resources = [
      "${aws_ecr_repository.ssr.*.arn}",
      "${aws_ecr_repository.wp.*.arn}",
      "${aws_ecr_repository.gw.*.arn}",
    ]
  }

  statement {
    sid    = "CodeBuildECRTokenPolicy"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CodeBuildECSPolicy"
    effect = "Allow"

    actions = [
      "ecs:*",
    ]

    resources = ["*"] # should be limited
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
    sid    = "CodePipelineLambdaPolicy"
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
    ]

    resources = [
      "*",
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

    resources = ["${var.kms_master_key_arn}"]
  }
}
