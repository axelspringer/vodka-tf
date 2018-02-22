output "default_alb_target_group" {
  value = "${module.alb.default_alb_target_group}"
}

output "cluster_id" {
  value = "${module.ecs.cluster_id}"
}

output "cluster_arn" {
  value = "${module.ecs.cluster_arn}"
}
