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
        "awslogs-region": "${log_region}"
      }
    },
    "portMappings": [{
      "containerPort": ${port},
      "protocol": "tcp"
    }],
    "essential": true,
    "environment": [
      "APP_KEY": "${app_key}",
      "DB_DRIVER": "${db_driver}",
      "DB_USERNAME": "${db_user}",
      "DB_HOST": "${db_host}",
      "DB_DATABASE": "${db_database}"
    ],
    "dockerLabels": {
      "traefik.frontend.rule": "Host:${route53_zone}",
      "traefik.frontend.passHostHeader": "true",
      "traefik.enable": "true",
      "traefik.frontend.entryPoints": "http"
    }
  }
]
