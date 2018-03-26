[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${mem},
    "memoryReservation": ${mem_res},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${log_region}",
        "awslogs-stream-prefix": "${log_prefix}"
      }
    },
    "portMappings": [{
      "containerPort": ${port},
      "protocol": "tcp"
    }],
    "dockerLabels": {
      "traefik.frontend.rule": "Host:${route53_zone}",
      "traefik.frontend.passHostHeader: "true",
      "traefik.enable": "true",
      "traefik.frontend.entryPoints": "http"
    }
  }
]
