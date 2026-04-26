#!/bin/bash

image_name="helixai"
container_name="helixai"
host_port=3000
container_port=8080

# Auto-install Ollama on the host if not present
if ! command -v ollama &>/dev/null; then
    echo "[HelixAI] Ollama not found on host. Installing..."
    bash scripts/install-ollama.sh
fi

docker build -t "$image_name" .
docker stop "$container_name" &>/dev/null || true
docker rm "$container_name" &>/dev/null || true

docker run -d -p "$host_port":"$container_port" \
    --add-host=host.docker.internal:host-gateway \
    -v "${image_name}:/app/backend/data" \
    --name "$container_name" \
    --restart always \
    "$image_name"

docker image prune -f
