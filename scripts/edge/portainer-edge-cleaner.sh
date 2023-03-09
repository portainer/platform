#!/usr/bin/env sh

set -e

cleanup_edge() {
  EDGE_KEY=$1
  PORTAINER_URL=$(echo ${EDGE_KEY} | base64 -d | cut -d '|' -f 1)
  PORTAINER_JWT=$(curl -k -X POST ${PORTAINER_URL}/api/auth -d '{"Username":'"\"${PORTAINER_ADMIN_USERNAME}\""',"Password":'"\"${PORTAINER_ADMIN_PASSWORD}\""'}' --silent --show-error --fail | jq '. | .jwt' | sed 's/\"//g')
  
  ENDPOINT_IDS=$(curl "${PORTAINER_URL}/api/endpoints" --silent -k -X GET -H "Authorization: Bearer ${PORTAINER_JWT}" | jq -r '.[] | select(.IsEdgeDevice == true) | select('$(date +%s)' - .LastCheckInDate > .EdgeCheckinInterval * 2 + 20) | .Id')

  if [ -z "${ENDPOINT_IDS}" ]; then
    echo "Endpoint not found"
  else
    for ENDPOINT_ID in $(echo ${ENDPOINT_IDS} | tr '\n' ' '); do
      echo "Deleting endpoint ${ENDPOINT_ID}"
      (curl "${PORTAINER_URL}/api/endpoints/${ENDPOINT_ID}" --silent -k -X DELETE -H "Authorization: Bearer ${PORTAINER_JWT}" &)
    done
  fi
}

cleanup_edge "$@"