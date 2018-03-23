[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${mem},
    "memoryReservation": ${mem_res},
    "command": [
      "--defaultentrypoints=http",
      "--entrypoints=Name:http Address::80",
      "--entrypoints=Name:web Address::8080",
      "--ecs",
      "--ecs.trace",
      "--ecs.exposedbydefault=false",
      "--ecs.region=${cluster_region}",
      "--ecs.clusters=${cluster_name}",
      "--api",
      "--api.dashboard",
      "--api.statistics",
      "--api.entrypoint=web",
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
      "hostPort": ${port_}
      "containerPort": ${port_web},
      "protocol": "tcp"
    }]
  }
]
