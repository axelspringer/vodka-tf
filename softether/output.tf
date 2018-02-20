output "id" {
  value       = "${ aws_instance.vpn.id }"
  description = "AWS instance id of the VPN"
}

output "public_ip" {
  value       = "${ aws_instance.vpn.public_ip }"
  description = "Public IP of the VPN"
}

output "private_ip" {
  value       = "${ aws_instance.vpn.private_ip }"
  description = "Private IP of the VPN"
}

output "acl_id" {
  value       = "${ aws_network_acl.main_acl.id }"
  description = "ACL id of the VPN"
}

output "security_group_id" {
  value       = "${ aws_security_group.main_sg.id }"
  description = "Security group id of the VPN" 
}

