output "ecs_instance_security_group_id" {
  value = "${module.ecs_instances.ecs_instance_security_group_id}"
}

output "cluster_ids" {
  value = "${aws_ecs_cluster.cluster.*.id}"
}

output "cluster_arns" {
  value = "${aws_ecs_cluster.cluster.*.arn}"
}
