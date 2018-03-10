#--------------------------------------------------------------
# This module creates a vpc in the designated AWS region
#--------------------------------------------------------------

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC."
  default     = []
}

variable "vpn_subnet" {
  description = "A subnet for VPN connection to VPC"
  default     = ""
}

variable "database_subnets" {
  type        = "list"
  description = "A list of database subnets"
  default     = []
}

variable "elasticache_subnets" {
  type        = "list"
  description = "A list of elasticache subnets"
  default     = []
}

variable "azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_nat_gateway" {
  description = "should be true if you want to provision NAT Gateways for each of your private networks"
  default     = false
}

variable "single_nat_gateway" {
  description = "should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "enable_s3_endpoint" {
  description = "should be true if you want to provision an S3 endpoint to the VPC"
  default     = false
}

variable "enable_ipv6" {
  description = "should be true, to enable IPv6 support"
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

variable "private_propagating_vgws" {
  description = "A list of VGWs the private route table should propagate."
  default     = []
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}

variable "vpn_propagating_vgws" {
  description = "A list of VGWs the vpn route table should propagate."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  default     = {}
}

variable "vpn_subnet_tags" {
  description = "Additional tags for the VPN subnet"
  default     = {}
}

variable "elasticache_subnet_tags" {
  description = "Additional tags for the elasticache subnets"
  default     = {}
}

variable "create_vpn" {
  description = "Create VPN and related resources"
  default     = true
}

output "kms_master_key_arn" {
  value = "${aws_kms_key.master.arn}"
}

output "kms_master_key_id" {
  value = "${aws_kms_key.master.id}"
}

output "kms_master_key_alias" {
  value = "${aws_kms_alias.master_alias.id}"
}

# !private
variable "_tags" {
  default = {
    terraform = "true"
  }
}

#! private
variable "_kms_deletion_window_in_days" {
  default = 30
}
