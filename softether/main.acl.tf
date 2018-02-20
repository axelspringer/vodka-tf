#--------------------------------------------------------------
# Recipe
# 
# + get res aws network acl
# + get res dynamic aws network acl
#--------------------------------------------------------------

# + get res aws network acl
resource "aws_network_acl" "main_acl" {
  vpc_id        = "${var.aws_vpc_id}"
  subnet_ids    = ["${var.aws_vpc_subnet_id}"]

  egress {
    protocol    = "-1"
    rule_no     = 100
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    protocol    = "tcp"
    rule_no     = 100
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    protocol    = "udp"
    rule_no     = 101
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 500
    to_port     = 500
  }

  ingress {
    protocol    = "udp"
    rule_no     = 102
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 4500
    to_port     = 4500
  }

  ingress {
    protocol    = "udp"
    rule_no     = 103
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 1024
    to_port     = 65535
  }

  ingress {
    protocol    = "tcp"
    rule_no     = 104
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 1024
    to_port     = 65535
  }

  ingress {
    protocol    = "47"
    rule_no     = 105
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    protocol    = "50"
    rule_no     = 106
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    protocol    = "51"
    rule_no     = 107
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    protocol    = "icmp"
    rule_no     = 108
    action      = "allow"
    cidr_block  =  "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  tags  = "${ merge( var.tags, map( "Name", var.name ), map( "Terraform", "true" ) ) }"
}

# + get res dynamic aws network acl
resource "aws_network_acl_rule" "main_rule" {
  network_acl_id  = "${ aws_network_acl.main_acl.id }"
  rule_number     = "900"
  egress          = false
  protocol        = "-1"
  rule_action     = "allow"
  cidr_block      = "${ var.aws_vpc_cidr }"
  from_port       = 0
  to_port         = 0
}
