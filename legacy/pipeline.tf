data "external" "lambda_arn" {
  count = "${length(local.branches)}"
  program = ["bash", "${path.root}/files/getLambda.sh"]

  query = {
    # arbitrary map from strings to strings, passed
    # to the external program as the data query.
    eid = "${var.deploy_functions_name}-${element(local.branches, count.index)}"
  }
}

resource "aws_codebuild_project" "default" {
  count          = "${length(local.branches)}"
  name           = "${var.cluster_name}-legacy-${element(local.branches, count.index)}"
  description    = "Build ${var.cluster_name} in ${element(local.branches, count.index)}"
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
      name  = "REPOSITORY_WP_URI"
      value = "${element(aws_ecr_repository.wp.*.repository_url, count.index)}"
    }

    environment_variable {
      name  = "BUILD_BRANCH"
      value = "${element(local.branches, count.index)}"
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
  count    = "${length(local.branches)}"
  name     = "${var.cluster_name}-legacy-${element(local.branches, count.index)}"
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
      output_artifacts = ["${var.cluster_name}-legacy-${element(local.branches, count.index)}-source"]

      configuration {
        Owner  = "${var.github_org}"
        Repo   = "${var.github_repo}"
        Branch = "${element(local.branches, count.index)}"
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
      input_artifacts  = ["${var.cluster_name}-legacy-${element(local.branches, count.index)}-source"]
      output_artifacts = ["${var.cluster_name}-legacy-${element(local.branches, count.index)}-build"]
      version          = "1"

      configuration {
        ProjectName = "${var.cluster_name}-legacy-${element(local.branches, count.index)}"
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
      input_artifacts = ["${var.cluster_name}-legacy-${element(local.branches, count.index)}-build"]

      # configuration {
      #   ClusterName = "${var.name}-${element(local.branches, count.index)}"
      #   ServiceName = "legacy-api"
      #   FileName    = "imagedefinitions.json"
      # }

      configuration {
        FunctionName = "${element(data.external.lambda_arn.*.result.lambdaname, count.index)}"
      }
    }
  }
}
