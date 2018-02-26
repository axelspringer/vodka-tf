output "registry_id" {
  value = "${aws_ecr_repository.default.*.registry_id}"
}

output "registry_url" {
  value = "${aws_ecr_repository.default.*.repository_url}"
}

output "repository_name" {
  value = "${aws_ecr_repository.default.*.name}"
}

output "cluster_alb_target_groups" {
  value = "${module.ecs.alb_target_groups}"
}

output "cluster_ids" {
  value = "${module.ecs.cluster_ids}"
}

output "cluster_arns" {
  value = "${module.ecs.cluster_arns}"
}

output "cluster_name" {
  value = "${var.name}"
}
