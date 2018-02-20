#--------------------------------------------------------------
# Recipe
# 
# + get res aws elastic ip
# + get res aws route53 domain
# + get res aws instance
#--------------------------------------------------------------

# + get res aws elastic ip
resource "aws_eip" "eip" {
  vpc       = true
  instance  = "${ aws_instance.vpn.id }"
}

# + get res aws route53 domain
data "aws_route53_zone" "domain" {
  name         = "${ var.aws_route53_domain }"
  private_zone = "${ var._aws_route53_domain_private_zone }"
}

resource "aws_route53_record" "vpn" {
  zone_id = "${ data.aws_route53_zone.domain.zone_id }"
  name    = "vpn.${ data.aws_route53_zone.domain.name }"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_eip.eip.public_ip }"]
}

# + get res aws instance
resource "aws_instance" "vpn" {
  ami                         = "${lookup(var.aws_ami_id, var.aws_region)}"
  key_name                    = "${ var.aws_key_name }"
  instance_type               = "${ var.aws_instance_type }"
  subnet_id                   = "${ var.aws_vpc_subnet_id }"

  # !security
  vpc_security_group_ids      = ["${ aws_security_group.main_sg.id }"]

  # !security
  associate_public_ip_address = "${ var.aws_public_ip }"

  lifecycle {
    create_before_destroy = false
  }

  tags  = "${ merge( var.tags, map( "Name", format( "%s", var.name ) ) ) }"
}
