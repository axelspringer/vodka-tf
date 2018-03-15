output "cluster_instance_security_group_id" {
  value = "${module.ecs.ecs_instance_security_group_id}"
}

output "cluster_ids" {
  value = "${module.ecs.cluster_ids}"
}

output "cluster_arns" {
  value = "${module.ecs.cluster_arns}"
}

output "cluster_iam_arn" {
  value = "${module.roles.iam_role_arn}"
}

output "cluster_name" {
  value = "${var.name}"
}

output "cluster_discovery_zone_id" {
  value = "${module.discovery.discovery_zone_id}"
}

output "cluster_discovery_servers" {
  value = "${module.discovery.discovery_servers}"
}
