#!/bin/bash
until docker info >/dev/null 2>&1; do sleep 1; done
docker start jobe >/dev/null 2>&1 || true
docker network connect uccser-development-stack jobe 2>/dev/null || true

nohup ./dev start > /tmp/dev.log 2>&1 &

# Public ports (needs GH_TOKEN secret); retries until the ports are forwarded
(
  for i in $(seq 1 60); do
    gh codespace ports visibility 8000:public -c "$CODESPACE_NAME" >/dev/null 2>&1 && exit 0
    sleep 5
  done
) > /tmp/public-ports.log 2>&1 &
