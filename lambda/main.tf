data "template_file" "default" {
  count  = "${length(var.branches)}"
  template = "${file("${path.module}/cf.json")}"

  vars {
    description = "${var.description}"
  }
}

resource "aws_cloudformation_stack" "default" {
  count   = "${length(var.branches)}"
  name    = "${var._prefix_tf_lambda}-${var.name}-${element(var.branches, count.index)}"

  template_body = "${element(data.template_file.default.*.rendered, count.index)}"

  parameters {
    ProjectId         = "${var._prefix_tf_lambda}-${var.name}-${element(var.branches, count.index)}"
    AppName           = "${var.name}-${element(var.branches, count.index)}"
    RepositoryBranch  = "${element(var.branches, count.index)}"
    RepositoryName    = "${var.repo}"
    RepositoryProviderUserId    = "${var.user_id}"
    RepositoryProviderUsername  = "${var.org}"
    RepositoryToken   = "${var.oauth_token}"
    RepositoryURL     = "${var.repo_url}"
  }

  capabilities = [,
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_IAM"
  ]
  on_failure = "${var._on_failure}"
}
