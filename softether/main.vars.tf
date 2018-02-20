variable "aws_instance_type"      { default = "m3.medium" }
variable "aws_region"             { default = "eu-west-1" }
variable "aws_ami_id"             { 
  default = {
    "eu-west-1" 	  = "ami-2dedca4b"
    "eu-central-1" 	= "ami-4372ba2c"
  }
}

variable "name"   { default = "" }

variable "aws_vpc_id"             { }
variable "aws_vpc_cidr"           { }
variable "aws_vpc_subnet_id"      { }
variable "aws_key_name"           { }
variable "aws_public_ip"          { default = true }

variable "aws_route53_domain"         { }

variable "security_group_name" {
  default = "softether"
}

variable "tags" { default = { } }

# ! Private variables
variable "_aws_route53_domain_private_zone"   { default = false }

