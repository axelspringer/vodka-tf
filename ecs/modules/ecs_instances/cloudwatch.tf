resource "aws_cloudwatch_log_group" "dmesg" {
  count             = "${length(var.branches)}"
  name              = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}/var/log/dmesg"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "docker" {
  name              = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}/var/log/docker"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs-agent" {
  name              = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}/var/log/ecs/ecs-agent.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs-init" {
  name              = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}/var/log/ecs/ecs-init.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "audit" {
  name              = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}/var/log/ecs/audit.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "messages" {
  name              = "${var.cloudwatch_prefix}-${element(var.branches, count.index)}/var/log/messages"
  retention_in_days = 30
}
