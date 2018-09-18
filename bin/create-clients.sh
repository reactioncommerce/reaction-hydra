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

docker-compose run --rm \
  --volume "${__dir}/wait-for.sh:/usr/local/bin/wait-for.sh" \
  hydra-clients <<'EOF'
set -e
/usr/local/bin/wait-for.sh "${HYDRA_HOST}:${HYDRA_ADMIN_PORT}"
# Want to check stderr on failure of the next command so +e
set +e
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
