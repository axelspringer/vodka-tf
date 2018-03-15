resource "aws_s3_bucket" "default" {
  count  = "${length(var.branches)}"
  bucket = "${var.cluster_name}-mango-pipeline-${element(var.branches, count.index)}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_ecr_repository" "ssr" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-ssr-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "ssr_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.ssr.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_ecr_repository" "wp" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-wp-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "wp_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.wp.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_ecr_repository" "gw" {
  count = "${length(var.branches)}"
  name  = "${var.cluster_name}-mango-gw-${element(var.branches, count.index)}"
}

resource "aws_ecr_repository_policy" "gw_ecr" {
  count      = "${length(var.branches)}"
  repository = "${element(aws_ecr_repository.gw.*.name, count.index)}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_codebuild_project" "default" {
  count          = "${length(var.branches)}"
  name           = "${var.cluster_name}-mango-${element(var.branches, count.index)}"
  description    = "Build ${var.cluster_name} in ${element(var.branches, count.index)}"
  build_timeout  = "${var._build_timeout}"
  service_role   = "${aws_iam_role.build.arn}"
  encryption_key = "${var.kms_master_key_arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "${var.build_compute_type}"
    image           = "${var.build_image}"
    type            = "${var.build_type}"
    privileged_mode = "${var._build_privileged_mode}"

    environment_variable {
      name  = "REPOSITORY_SSR_URI"
      value = "${element(aws_ecr_repository.ssr.*.repository_url, count.index)}"
    }

    environment_variable {
      name  = "REPOSITORY_WP_URI"
      value = "${element(aws_ecr_repository.wp.*.repository_url, count.index)}"
    }

    environment_variable {
      name  = "REPOSITORY_GW_URI"
      value = "${element(aws_ecr_repository.gw.*.repository_url, count.index)}"
    }

    environment_variable {
      name  = "BUILD_BRANCH"
      value = "${element(var.branches), count.index)}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  tags {
    "Environment" = "Test"
  }
}

resource "aws_codepipeline" "pipeline" {
  count    = "${length(var.branches)}"
  name     = "${var.cluster_name}-mango-${element(var.branches, count.index)}"
  role_arn = "${aws_iam_role.pipeline.arn}"

  artifact_store {
    location = "${element(aws_s3_bucket.default.*.bucket, count.index)}"
    type     = "S3"

    encryption_key {
      id   = "${var.kms_master_key_arn}"
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
      output_artifacts = ["${var.cluster_name}-mango-${element(var.branches, count.index)}-source"]

      configuration {
        Owner  = "${var.github_org}"
        Repo   = "${var.github_repo}"
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
      input_artifacts  = ["${var.cluster_name}-mango-${element(var.branches, count.index)}-source"]
      output_artifacts = ["${var.cluster_name}-mango-${element(var.branches, count.index)}-build"]
      version          = "1"

      configuration {
        ProjectName = "${var.cluster_name}-mango-${element(var.branches, count.index)}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      version         = "1"
      input_artifacts = ["${var.cluster_name}-mango-${element(var.branches, count.index)}-build"]

      # configuration {
      #   ClusterName = "${var.name}-${element(var.branches, count.index)}"
      #   ServiceName = "mango-api"
      #   FileName    = "imagedefinitions.json"
      # }

      configuration {
        FunctionName = "${element(var.deploy_functions, count.index)}"
      }
    }
  }
}
