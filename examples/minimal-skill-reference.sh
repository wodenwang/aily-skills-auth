#!/usr/bin/env bash

set -euo pipefail

SKILL_ID="${SKILL_ID:-sales-analysis}"
USER_ID="${USER_ID:-ou_abc123}"
AGENT_ID="${AGENT_ID:-host-vm-a1b2c3d4}"
CHAT_ID="${CHAT_ID:-oc_sales_weekly}"
SERVICE_URL="${SERVICE_URL:-http://127.0.0.1:9000/api/demo/query}"

AUTH_JSON="$(
  auth-cli check \
    --skill "${SKILL_ID}" \
    --user-id "${USER_ID}" \
    --agent-id "${AGENT_ID}" \
    --chat-id "${CHAT_ID}" \
    --format json
)"

if jq -e '.ok == true and .allowed == true' >/dev/null <<<"${AUTH_JSON}"; then
  ACCESS_TOKEN="$(jq -r '.access_token' <<<"${AUTH_JSON}")"
  curl -sS -X POST \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "X-Auth-User-ID: ${USER_ID}" \
    -H "X-Auth-Skill-ID: ${SKILL_ID}" \
    -H "X-Auth-Agent-ID: ${AGENT_ID}" \
    -H "X-Aily-Chat-Id: ${CHAT_ID}" \
    -H "Content-Type: application/json" \
    -d '{"query":"sales summary"}' \
    "${SERVICE_URL}"
  exit 0
fi

jq -r '.deny_message // "auth failed"' <<<"${AUTH_JSON}" >&2
exit 10
