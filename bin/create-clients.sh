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

docker_image="oryd/hydra:v1.0.0-beta.9-alpine"
network="auth.reaction.localhost"
hydra_host="hydra.${network}"
hydra_admin_port="4445"
hydra_admin_url="http://${hydra_host}:${hydra_admin_port}"
docker run --rm \
  --interactive \
  --volume "${__dir}/wait-for.sh:/usr/local/bin/wait-for.sh" \
  --network "${network}" \
  --env "HYDRA_HOST=${hydra_host}" \
  --env "HYDRA_ADMIN_PORT=${hydra_admin_port}" \
  --env "HYDRA_ADMIN_URL=${hydra_admin_url}" \
  --env "HYDRA_CLIENT_SECRET" \
  --network "${network}" \
  --entrypoint sh \
  "${docker_image}" <<'EOF'
/usr/local/bin/wait-for.sh "${HYDRA_HOST}:${HYDRA_ADMIN_PORT}"
hydra clients create --skip-tls-verify \
  --id reaction-next-starterkit \
  --secret "${HYDRA_CLIENT_SECRET-CHANGEME}" \
  --grant-types authorization_code,refresh_token,client_credentials,implicit \
  --token-endpoint-auth-method client_secret_post \
  --response-types token,code,id_token \
  --scope openid,offline \
  --callbacks http://localhost:4000/callback 2>/tmp/clients-create-stderr
exit_code=$?
case ${exit_code} in
0)
  echo SUCCESS: hydra client created
  ;;
*)
  if grep 409 /tmp/clients-create-stderr >/dev/null; then
    echo SUCCESS: hydra client already exists
  else
    echo ERROR: creating hydra client 1>&2
    cat /tmp/clients-create-stderr 1>&2
    exit ${exit_code}
  fi
  ;;
esac
EOF
