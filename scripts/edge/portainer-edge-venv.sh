#!/usr/bin/env sh

# Description: Queries a Portainer instance API to create an Edge environment and runs a local Portainer agent
# as a standalone Docker container. The local Portainer agent is then connected to the Edge environment.

set -e

# logging

ESeq="\x1b["
RCol="$ESeq"'0m'
BIRed="$ESeq"'1;91m'
BIGre="$ESeq"'1;92m'
BIYel="$ESeq"'1;93m'
BIWhi="$ESeq"'1;97m'

printSection() {
  echo -e "${BIYel}>>>> ${BIWhi}${1}${RCol}"
}

info() {
  echo -e "${BIWhi}${1}${RCol}"
}

success() {
  echo -e "${BIGre}${1}${RCol}"
}

error() {
  echo -e "${BIRed}${1}${RCol}"
}

errorAndExit() {
  echo -e "${BIRed}${1}${RCol}"
  exit 1
}

# !logging

retrieve_edge_id() {
  EDGE_ID_FILE_LOCATION="/edge/${CONTAINER_NAME}.id"
  if [ ! -f "${EDGE_ID_FILE_LOCATION}" ]; then
    uuidgen > ${EDGE_ID_FILE_LOCATION}
  fi
  export EDGE_ID=$(cat ${EDGE_ID_FILE_LOCATION})
}

deploy_edge() {
  PORTAINER_AGENT="${1}"
  EDGE_KEY="${2}"
  EDGE_ASYNC="${3}"

  info "Checking Docker readyness"

  until docker info
  do
    error "Docker not ready yet - retrying in 5 seconds"
    sleep 5
  done

  info "Retrieving Portainer Edge ID..."
  # retrieve_edge_id
  export EDGE_ID="${POD_NAME}-${CONTAINER_SEQUENCE}"

  info "Deploying Portainer Edge agent using Edge key ${EDGE_KEY}..."
  echo "Sleeping for ${CONTAINER_SEQUENCE}"
  sleep ${CONTAINER_SEQUENCE}
  
  CONTAINER_ID=$(docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    -v /:/host \
    -v portainer_agent_data:/data \
    --restart always \
    --pull never \
    -e EDGE=1 \
    -e EDGE_ID=${EDGE_ID} \
    -e EDGE_KEY=${EDGE_KEY} \
    -e EDGE_INSECURE_POLL=1 \
    -e EDGE_ASYNC=${EDGE_ASYNC} \
    -e LOG_LEVEL=DEBUG \
    ${PORTAINER_AGENT})
    
    docker logs -f ${CONTAINER_ID} || cleanup_edge
}

deploy_edge "$@"