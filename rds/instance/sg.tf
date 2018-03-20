# + get res Database security group
resource "aws_security_group" "default" {
  name        = "${var.name}-rds"
  description = "Allow all database and SSH traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${concat(var.vpc_cidr_private_subnets, var.vpc_cidr_vpn_subnets, var.vpc_cidr_database_subnets)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${concat(var.vpc_cidr_private_subnets, var.vpc_cidr_vpn_subnets, var.vpc_cidr_database_subnets)}"]
  }

  tags = "${merge(var.tags, map("Name", "${var.name}-rds"), map("Terraform", "true"))}"
}
