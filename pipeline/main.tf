resource "aws_s3_bucket" "default" {
  count  = "${length(var.branches)}"
  bucket = "${var.name}-pipeline-${element(var.branches, count.index)}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_ecr_repository" "default" {
  count = "${length(var.branches)}"
  name  = "${var.name}-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "default_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.default.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_codebuild_project" "default" {
  count          = "${length(var.branches)}"
  name           = "${var.name}-${element(var.branches, count.index)}"
  description    = "Build ${var.name} in ${element(var.branches, count.index)}"
  build_timeout  = "5"
  service_role   = "${aws_iam_role.build.arn}"
  encryption_key = "${element(aws_kms_key.s3key.*.arn, count.index)}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "${var.build_compute_type}"
    image        = "${var.build_image}"
    type         = "${var.build_type}"

    environment_variable {
      "name"  = "SOME_KEY1"
      "value" = "SOME_VALUE1"
    }

    environment_variable {
      "name"  = "SOME_KEY2"
      "value" = "SOME_VALUE2"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  # vpc_config {
  #   vpc_id = "vpc-725fca"


  #   subnets = [
  #     "subnet-ba35d2e0",
  #     "subnet-ab129af1",
  #   ]


  #   security_group_ids = [
  #     "sg-f9f27d91",
  #     "sg-e4f48g23",
  #   ]
  # }

  tags {
    "Environment" = "Test"
  }
}

resource "aws_codepipeline" "pipeline" {
  count    = "${length(var.branches)}"
  name     = "${var.name}-${element(var.branches, count.index)}"
  role_arn = "${aws_iam_role.pipeline.arn}"

  artifact_store {
    location = "${element(aws_s3_bucket.default.*.bucket, count.index)}"
    type     = "S3"

    encryption_key {
      id   = "${element(aws_kms_key.s3key.*.arn, count.index)}"
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["${var.name}-${element(var.branches, count.index)}-source"]

      configuration {
        Owner  = "${var.org}"
        Repo   = "${var.repo}"
        Branch = "${element(var.branches, count.index)}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.name}-${element(var.branches, count.index)}-source"]
      output_artifacts = ["${var.name}-${element(var.branches, count.index)}-build"]
      version          = "1"

      configuration {
        ProjectName = "${var.name}-${element(var.branches, count.index)}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["${var.name}-${element(var.branches, count.index)}-build"]

      configuration {
        ClusterName = "${var.name}-${element(var.branches, count.index)}"
        ServiceName = "mango_api"
      }
    }
  }
}
