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

resource "aws_iam_group_policy_attachment" "assume_role_dev" {
  group      = "${aws_iam_group.devs.name}"
  policy_arn = "${aws_iam_policy.assume_role_dev.arn}"
}

resource "aws_iam_group_policy_attachment" "assume_role_op" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.assume_role_op.arn}"
}

resource "aws_iam_group_policy_attachment" "assume_role_consumer" {
  group      = "${aws_iam_group.consumers.name}"
  policy_arn = "${aws_iam_policy.assume_role_consumer.arn}"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "manage_mfa" {
  name        = "${var.project}-${terraform.workspace}-mfa"
  description = "Allow users to manage there only mfa"
  policy      = "${data.aws_iam_policy_document.manage_mfa.json}"
}

resource "aws_iam_policy" "allow_change_password" {
  name        = "${var.project}-${terraform.workspace}-password"
  description = "Allow users to change password"
  policy      = "${data.aws_iam_policy_document.allow_change_password.json}"
}

resource "aws_iam_policy" "assume_role_dev" {
  name        = "${var.project}-${terraform.workspace}-assume-dev"
  description = "Allow assuming dev role"
  policy      = "${data.aws_iam_policy_document.assume_role_dev.json}"
}

resource "aws_iam_policy" "assume_role_op" {
  name        = "${var.project}-${terraform.workspace}-assume-op"
  description = "Allow assuming dev role"
  policy      = "${data.aws_iam_policy_document.assume_role_op.json}"
}

resource "aws_iam_policy" "assume_role_consumer" {
  name        = "${var.project}-${terraform.workspace}-assume-consumer"
  description = "Allow assuming dev role"
  policy      = "${data.aws_iam_policy_document.assume_role_consumer.json}"
}

resource "aws_iam_group_policy_attachment" "devs_manage_mfa" {
  group      = "${aws_iam_group.devs.name}"
  policy_arn = "${aws_iam_policy.manage_mfa.arn}"
}

resource "aws_iam_group_policy_attachment" "ops_manage_mfa" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.manage_mfa.arn}"
}

resource "aws_iam_group_policy_attachment" "devs_password" {
  group      = "${aws_iam_group.devs.name}"
  policy_arn = "${aws_iam_policy.allow_change_password.arn}"
}

resource "aws_iam_group_policy_attachment" "ops_password" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.allow_change_password.arn}"
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

data "aws_iam_policy_document" "assume_role_dev" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.dev.arn}"]
  }
}

data "aws_iam_policy_document" "assume_role_op" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.op.arn}"]
  }
}

data "aws_iam_policy_document" "assume_role_consumer" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.consumer.arn}"]
  }
}

data "aws_iam_policy_document" "manage_mfa" {
  statement {
    sid = "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid = "AllowUsersToListMFADevicesandUsersForConsole"

    actions = [
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ListUsers",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "allow_change_password" {
  statement {
    actions   = ["iam:ChangePassword"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"]
  }

  statement {
    actions   = ["iam:GetAccountPasswordPolicy"]
    resources = ["*"]
  }
}
