#!/bin/bash
set -e

IMAGE="$1"

set -a
# shellcheck disable=SC1090
source ~/insighton-config/eureka.env
set +a

deploy_replica() {
  local name=$1
  local profile=$2
  local port=$3

  echo "----- Deploying $name (profile $profile, port $port) -----"

  docker stop -t 15 "$name" > /dev/null 2>&1 || true
  docker rm "$name" > /dev/null 2>&1 || true

  docker run -d \
    --name "$name" \
    --network host \
    -e SPRING_PROFILES_ACTIVE="$profile" \
    -e USERNAME="$USERNAME" \
    -e USERPASSWORD="$USERPASSWORD" \
    --restart unless-stopped \
    "$IMAGE"

  echo "Waiting for $name to become healthy..."
  for i in $(seq 1 30); do
    if curl -sf -u "${USERNAME}:${USERPASSWORD}" "http://127.0.0.1:${port}/actuator/health" > /dev/null 2>&1; then
      echo "$name is healthy (attempt $i)"
      return 0
    fi
    sleep 2
  done

  echo "$name failed health check!"
  return 1
}

echo "Pulling image $IMAGE"
docker pull "$IMAGE"

deploy_replica "insighton-eureka-1" "peer1" "10444"
deploy_replica "insighton-eureka-2" "peer2" "10445"

echo "Rolling deployment complete!"