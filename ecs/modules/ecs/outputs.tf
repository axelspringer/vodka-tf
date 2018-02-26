output "default_alb_target_groups" {
  value = "${module.alb.default_alb_target_groups}"
}

output "cluster_ids" {
  value = "${aws_ecs_cluster.cluster.*.id}"
}

output "cluster_arns" {
  value = "${aws_ecs_cluster.cluster.*.arn}"
}
