module "ecs" {
  source = "modules/ecs"

  availability_zones   = "${var.availability_zones}"
  cloudwatch_prefix    = "${var.environment}"           #See ecs_instances module when to set this and when not!
  cluster              = "${var.environment}"
  desired_capacity     = "${var.desired_capacity}"
  ecs_aws_ami          = "${var.ecs_aws_ami}"
  environment          = "${var.environment}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  vpc_cidr             = "${var.vpc_cidr}"
}
