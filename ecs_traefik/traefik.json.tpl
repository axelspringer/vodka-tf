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
      "--entrypoints=Name:dashboard Address::8080",
      "--api",
      "--api.dashboard",
      "--api.statistics",
      "--api.entrypoint=dashboard",
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
    "portMappings": [{
      "containerPort": ${port_web},
      "hostPort": ${port_web}
    },
    {
      "containerPort": ${port_http},
      "hostPort": ${port_http}
    },
    {
      "containerPort": ${port_https},
      "hostPort": ${port_https}
    }]
  }
]
