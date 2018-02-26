resource "aws_security_group" "instance" {
  name   = "${var.cluster}-ec2"
  vpc_id = "${var.vpc_id}"

  tags = "${ merge( var.tags, map( "Name", "${var.cluster}-${element(var.branches, count.index)}" ), map( "Terraform", "true" ) ) }"
}

# We separate the rules from the aws_security_group because then we can manipulate the
# aws_security_group outside of this module
resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"
}

# Default disk size for Docker is 22 gig, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
resource "aws_launch_configuration" "launch" {
  count = "${length(var.branches)}"

  name_prefix          = "${var.cluster}-${element(var.branches, count.index)}-${var.instance_group}-"
  image_id             = "${var.aws_ami}"
  instance_type        = "${element(var.instance_type, count.index)}"
  security_groups      = ["${aws_security_group.instance.id}"]
  user_data            = "${element(data.template_file.user_data.*.rendered, count.index)}"
  iam_instance_profile = "${element(var.iam_instance_profile_ids, count.index)}"
  key_name             = "${var.key_name}"

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html
resource "aws_autoscaling_group" "asg" {
  count = "${length(var.branches)}"

  name                 = "${var.cluster}-${element(var.branches, count.index)}-${var.instance_group}"
  max_size             = "${element(var.max_size, count.index)}"
  min_size             = "${element(var.min_size, count.index)}"
  desired_capacity     = "${element(var.desired_capacity, count.index)}"
  force_delete         = true
  launch_configuration = "${element(aws_launch_configuration.launch.*.id, count.index)}"
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]
}

data "template_file" "user_data" {
  count    = "${length(var.branches)}"
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars {
    ecs_config        = "${var.ecs_config}"
    ecs_logging       = "${var.ecs_logging}"
    cluster_name      = "${var.cluster}-${element(var.branches, count.index)}"
    env_name          = "${var.cluster}-${element(var.branches, count.index)}"
    custom_userdata   = "${var.custom_userdata}"
    cloudwatch_prefix = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}"
  }
}
