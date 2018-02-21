resource "aws_s3_bucket" "default" {
  bucket = "${var.name}-pipeline"
  acl    = "private"
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.name}"
  role_arn = "${aws_iam_role.default.arn}"

  artifact_store {
    location = "${aws_s3_bucket.default.bucket}"
    type     = "S3"

    encryption_key {
      id   = "${aws_kms_key.s3key.arn}"
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
      output_artifacts = ["${var.artifacts}"]

      configuration {
        Owner  = "${var.org}"
        Repo   = "${var.repo}"
        Branch = "${var.branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["${var.artifacts}"]
      version         = "1"

      configuration {
        ProjectName = "${var.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
    }
  }
}
