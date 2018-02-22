output "default_alb_target_group" {
  value = "${module.ecs.default_alb_target_group}"
}

output "cluster_id" {
  value = "${module.ecs.aws_ecs_cluster.cluster.id}"
}

output "cluster_arn" {
  value = "${module.ecs.aws_ecs_cluster.cluster.arn}"
}
