#!/usr/bin/env bash
# Creates basic OAuth2 clients.
#
# WARNING!!! WARNING!!! WARNING!!!
# For DEVELOPMENT USE ONLY!
#
#   * You should not provide secrets using command line flags.
#     The secret might leak to bash history and similar systems.
#   * The passwords used here are VERY INSECURE.
#   * Restrict grant-types to a FEW AS POSSIBLE.
#   * Restrict scope as much as possible.

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker_image=oryd/hydra:v1.0.0-beta.9-alpine
network=auth.reaction.localhost
hydra_admin_port=4445
hydra_admin_url=http://hydra.${network}:${hydra_admin_port}

# Logs a warning and fails silently for now. Hydra doesn't support updating
# with this command.
docker run --rm -it \
  --network "${network}" \
  --volume "${__dir}/wait-for-it.sh:/usr/local/bin/wait-for-it.sh" \
  -e "HYDRA_ADMIN_URL=${hydra_admin_url}" \
  --network "${network}" \
  "${docker_image}" \
  clients create --skip-tls-verify \
    --id reaction-next-starterkit \
    --secret CHANGEME \
    --grant-types authorization_code,refresh_token,client_credentials,implicit \
    --response-types token,code,id_token \
    --scope openid,offline \
    --callbacks http://localhost:4000/callback \
  || echo "Failed to create OAuth2 client 'reaction-next-starterkit'"
