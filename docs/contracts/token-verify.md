# Token Verify Contract

## Endpoint

- `POST /api/v1/token/verify`

## Request

```json
{
  "token": "eyJ...",
  "user_id": "ou_abc123",
  "skill_id": "sales-analysis",
  "agent_id": "host-vm-a1b2c3d4"
}
```

## Success Response

```json
{
  "valid": true,
  "token_info": {
    "jti": "jt_xxx",
    "user_id": "ou_abc123",
    "skill_id": "sales-analysis",
    "agent_id": "host-vm-a1b2c3d4"
  },
  "permissions": ["sales:read"],
  "data_scope": {
    "data_level": "department",
    "dept_ids": ["D001"]
  }
}
```

## Failure Codes

- `TOKEN_EXPIRED`
- `TOKEN_INVALID`
- `TOKEN_REVOKED`
- `IDENTITY_MISMATCH`
- `AUDIENCE_MISMATCH`
- `SIGNATURE_INVALID`
