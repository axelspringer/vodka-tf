[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${mem},
    "healthCheck": {
      "command": [ "CMD-SHELL", "/bin/gibson check --url http://localhost || exit 1" ],
      "retries": 3,
      "timeout": 60,
      "interval": 30,
      "startPeriod": 60
    },
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
       { "name" : "TEMPLETON_PATH", "value" : "${templeton_path}" }
    ],
    "dockerLabels": {
      "traefik.frontend.rule": "Host:${route53_zone}",
      "traefik.enable": "true",
      "traefik.frontend.passHostHeader": "true",
      "traefik.frontend.entryPoints": "http"
      "traefik.frontend.whiteList.useXForwardedFor": "true",
      "traefik.frontend.whiteList.sourceRange": "${whitelist}"
    }
  }
]
