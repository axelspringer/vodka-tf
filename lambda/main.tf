data "template_file" "default" {
  count    = "${length(var.github_branches)}"
  template = "${file("${path.module}/cf.json")}"

  vars {
    description = "${var.description}"
  }
}

resource "aws_cloudformation_stack" "default" {
  count = "${length(var.github_branches)}"
  name  = "${var.name}-${element(var.github_branches, count.index)}"

  template_body = "${element(data.template_file.default.*.rendered, count.index)}"

  parameters {
    ProjectId                  = "${var.name}-${element(var.github_branches, count.index)}"
    KMSParameterArn            = "${var.kms_master_key_arn}"
    SSMParameterPrefix         = "${var.name}"                                              # we use this project as prefix
    AppName                    = "${var.name}-${element(var.github_branches, count.index)}"
    VpcId                      = "${var.vpc_id}"
    VpcSubnetIds               = "${join(",", compact(var.vpc_subnet_ids))}"
    VpcSecurityGroupIds        = "${join(",", compact(var.vpc_security_group_ids))}"
    BuildImage                 = "${var.codebuild_image}"
    BuildType                  = "${var.codebuild_type}"
    RepositoryBranch           = "${element(var.github_branches, count.index)}"
    RepositoryName             = "${var.github_repo}"
    RepositoryProviderUsername = "${var.github_org}"
    RepositoryToken            = "${var.github_oauth_token}"
    RepositoryURL              = "${var.github_repo_url}"
  }

  capabilities = [
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_IAM",
  ]

  on_failure = "${var._on_failure}"
}
