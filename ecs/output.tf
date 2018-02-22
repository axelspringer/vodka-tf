output "default_alb_target_group" {
  value = "${module.ecs.default_alb_target_group}"
}

output "cluster_id" {
  value = "${module.ecs.cluster_id}"
}

output "cluster_arn" {
  value = "${module.ecs.cluster_arn}"
}

output "iam_role_arn" {
  value = "${module.roles.iam_role_arn}"
}
