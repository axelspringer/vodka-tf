output "alb_target_group" {
  value = "${module.ecs.default_alb_target_group}"
}

output "id" {
  value = "${module.ecs.cluster_id}"
}

output "arn" {
  value = "${module.ecs.cluster_arn}"
}

output "iam_arn" {
  value = "${module.roles.iam_role_arn}"
}
