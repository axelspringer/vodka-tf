# + get res AWS IAM Role Traefik task
resource "aws_iam_role" "task" {
  name               = "${var.cluster_name}-task-traefik"
  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

# + get res AWS IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "task" {
  role       = "${aws_iam_role.task.name}"
  policy_arn = "${aws_iam_policy.task.arn}"
}

# + get res AWS IAM Task Policy
resource "aws_iam_policy" "task" {
  name        = "${var.cluster_name}-task-traefik"
  description = "Allow ECS task to call AWS APIs"
  policy      = "${data.aws_iam_policy_document.task_policy.json}"
}

# + get data AWS IAM Role Policy
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

# + get data AWS IAM Task Policy
data "aws_iam_policy_document" "task_policy" {
  statement {
    sid    = "ECSTaskPolicyKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "${var.kms_master_key_arn}",
    ]
  }

  statement {
    sid    = "ECSReadAccess"
    effect = "Allow"

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "ECSTaskPolicy"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.cluster_name}-traefik-*",
    ]
  }
}
