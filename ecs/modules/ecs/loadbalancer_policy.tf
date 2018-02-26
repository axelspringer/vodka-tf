data "aws_iam_policy_document" "ecs_lb_role" {
  statement {
    sid = "ECSLbRole"

    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_lb_role" {
  count = "${length(var.branches)}"
  name  = "${var.cluster}-${element(var.branches, count.index)}-ecs-lb"
  path  = "/ecs/"

  assume_role_policy = "${data.aws_iam_policy_document.ecs_lb_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_lb" {
  count      = "${length(var.branches)}"
  role       = "${element(aws_iam_role.ecs_lb_role.*.id, count.index)}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
