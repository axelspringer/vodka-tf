data "aws_iam_policy_document" "ecs_instance_role_policy" {
  statement {
    sid = "EC2InstanceRole"

    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs_instance_ecr" {
  count  = "${length(var.branches)}"
  name   = "${var.cluster}-${element(var.branches, count.index)}-ecs"
  policy = "${data.aws_iam_policy_document.ecr_policy.json}"
}

resource "aws_iam_role" "ecs_instance_role" {
  count = "${length(var.branches)}"
  name  = "${var.cluster}-${element(var.branches, count.index)}-ecs-instance"

  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_role_policy.json}"
}

resource "aws_iam_instance_profile" "ecs" {
  count = "${length(var.branches)}"
  name  = "${var.cluster}-${element(var.branches, count.index)}-ecs"
  path  = "/"
  role  = "${element(aws_iam_role.ecs_instance_role.*.name, count.index)}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.ecs_instance_role.*.id, count.index)}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.ecs_instance_role.*.id, count.index)}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_ecr_role" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.ecs_instance_role.*.id, count.index)}"
  policy_arn = "${element(aws_iam_policy.ecs_instance_ecr.*.id, count.index)}"
}
