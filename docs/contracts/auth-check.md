# Auth Check Contract

## Endpoint

- `POST /api/v1/auth/check`

## Request

```json
{
  "user_id": "ou_abc123",
  "skill_id": "sales-analysis",
  "agent_id": "host-vm-a1b2c3d4",
  "chat_id": "oc_sales_weekly",
  "context": {
    "requested_action": "read",
    "period": "2026-03"
  }
}
```

## Success Response

```json
{
  "request_id": "req_abc123",
  "allowed": true,
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 300,
  "refresh_before": 240,
  "permissions": ["sales:read"],
  "data_scope": {
    "data_level": "department",
    "dept_ids": ["D001"]
  },
  "cache_ttl": 280
}
```

## Denied Response

```json
{
  "request_id": "req_abc123",
  "allowed": false,
  "deny_code": "CHAT_SKILL_DENIED",
  "deny_message": "该群聊未开放此 Skill"
}
```

## Error Codes

- `PERMISSION_DENIED`
- `USER_NOT_FOUND`
- `AGENT_NOT_REGISTERED`
- `SKILL_NOT_FOUND`
- `CHAT_SKILL_DENIED`
- `CHAT_NOT_REGISTERED`
- `RATE_LIMITED`
- `GATEWAY_UNAVAILABLE`
