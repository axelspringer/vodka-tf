module "ecs" {
  source = "modules/ecs"

  availability_zones = "${var.availability_zones}"
  cloudwatch_prefix  = "${var.environment}"        #See ecs_instances module when to set this and when not!
  cluster            = "${var.environment}"
  desired_capacity   = "${var.desired_capacity}"
  ecs_aws_ami        = "${var.ecs_aws_ami}"
  environment        = "${var.environment}"
  instance_type      = "${var.instance_type}"
  key_name           = "${var.key_name}"
  max_size           = "${var.max_size}"
  min_size           = "${var.min_size}"
  private_subnet_ids = "${var.private_subnet_ids}"
  public_subnet_ids  = "${var.public_subnet_ids}"
  vpc_id             = "${var.vpc_id}"
}
