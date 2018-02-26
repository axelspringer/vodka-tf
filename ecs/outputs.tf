output "alb_target_groups" {
  value = "${module.ecs.default_alb_target_groups}"
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
