[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${mem},
    "memoryReservation": ${mem_res},
    "command": [
      "--ecs",
      "--ecs.trace",
      "--ecs.exposedbydefault=false",
      "--ecs.region=${cluster_region}",
      "--ecs.clusters=${cluster_name}",
      "--defaultentrypoints=http",
      "--entrypoints=Name:http Address::80",
      "--api",
      "--api.dashboard",
      "--api.statistics",
      "--api.entrypoint=http",
      "--ping",
      "--ping.entrypoint=http"
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${log_region}"
      }
    },
    "portMappings": [
    {
      "containerPort": ${port_http},
      "protocol": "tcp"
    },
    {
      "containerPort": ${port_https},
      "protocol": "tcp"
    }]
  }
]
