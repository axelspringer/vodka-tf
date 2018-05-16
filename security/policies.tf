# + get resource IAM Policy for Terraform admins
resource "aws_iam_policy" "tf_admin" {
  name = "tf-${var.project}-${terraform.workspace}-admin"
  path = "/"

  policy = "${data.aws_iam_policy_document.tf_admin.json}"
}

# + get resource IAM Policy for Terraform consumer
resource "aws_iam_policy" "tf_consumer" {
  name = "tf-${var.project}-${terraform.workspace}-consumer"
  path = "/"

  policy = "${data.aws_iam_policy_document.tf_consumer.json}"
}

# + get resource IAM Policy attachment for Terraform admins
resource "aws_iam_group_policy_attachment" "tf_admins_ec" {
  group      = "${aws_iam_group.tf_admins.name}"
  policy_arn = "${data.aws_iam_policy.ec2_full_access.arn}"
}

# + get resource IAM Policy allow assuming role
resource "aws_iam_policy" "assume_role_admin" {
  name        = "${var.project}-${terraform.workspace}-admin"
  description = "Allow assuming admin role"
  policy      = "${data.aws_iam_policy_document.assume_role_admin.json}"
}

resource "aws_iam_group_policy_attachment" "assume_role_admin" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${aws_iam_policy.assume_role_admin.arn}"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# + get resource IAM Policy Ec2 policy
data "aws_iam_policy" "ec2_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# + get data IAM Assume Policy Document for Terraform
data "aws_iam_policy_document" "tf_trust" {
  statement {
    sid     = "TerraformAssumeAccount"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

# + get data IAM Policy Document for Terraform admin
data "aws_iam_policy_document" "tf_admin" {
  statement {
    sid = "TerraformFullAccess"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "dynamodb:*",
    ]

    resources = [
      "${data.aws_s3_bucket.tf_state.arn}",
      "${data.aws_s3_bucket.tf_state.arn}/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${data.aws_dynamodb_table.tf_lock.name}",
    ]
  }
}

# + get data IAM Policy Document for Terraform consumer
data "aws_iam_policy_document" "tf_consumer" {
  statement {
    sid = "TerraformReadOnly"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "dynamodb:GetItem",
    ]

    resources = [
      "${data.aws_s3_bucket.tf_state.arn}",
      "${data.aws_s3_bucket.tf_state.arn}/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${data.aws_dynamodb_table.tf_lock.name}",
    ]
  }
}

# + get data IAM Policy Document for allowing users to change role
data "aws_iam_policy_document" "role_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_admin" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.admin.arn}"]
  }
}
