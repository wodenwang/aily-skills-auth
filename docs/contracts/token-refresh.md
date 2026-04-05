# Token Refresh Contract

## Endpoint

- `POST /api/v1/token/refresh`

## Request

```json
{
  "token": "eyJ..."
}
```

## Success Response

```json
{
  "access_token": "eyJ...new",
  "expires_in": 300,
  "refresh_before": 240,
  "old_token_status": "refreshed"
}
```

## Rules

- 只允许刷新尚未过期、且未被撤销的 token
- 旧 token 允许短暂过渡窗口
- 刷新后必须可追踪 `refreshed_from_jti`

## Failure Codes

- `TOKEN_EXPIRED`
- `TOKEN_REVOKED`
- `TOKEN_INVALID`
