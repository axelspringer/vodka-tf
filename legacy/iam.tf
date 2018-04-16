data "aws_iam_policy_document" "role" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "default" {
  name = "${var.cluster_name}-legacy-api"
  path = "/ecs/"

  assume_role_policy = "${data.aws_iam_policy_document.role.json}"
}

resource "aws_iam_policy" "default" {
  name = "${var.cluster_name}-legacy-api"
  path = "/"

  policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_policy_attachment" "default" {
  name       = "${var.cluster_name}-legacy-api"
  roles      = ["${aws_iam_role.default.name}"]
  policy_arn = "${aws_iam_policy.default.arn}"
}
