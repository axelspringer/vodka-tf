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
    "environment": [
       { "name" : "TEMPLETON_PATH", "value" : "${templeton_path}" },
       { "name" : "WP_ORIGIN", "value" : "${wp_origin}" },
       { "name" : "ENVIRONMENT", "value" : "${environment}" },
       { "name" : "WP_LAYER", "value" : "${wp_layer}" }
    ],
    "dockerLabels": {
      "traefik.frontend.rule": "Host:${route53_zone}",
      "traefik.enable": "true",
      "traefik.frontend.passHostHeader": "true",
      "traefik.frontend.entryPoints": "http",
      "traefik.frontend.whiteList.useXForwardedFor": "true",
      "traefik.frontend.whiteList.sourceRange": "${whitelist}"

    }
  }
]
