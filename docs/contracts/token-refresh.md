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
  "old_token_status": "refreshed",
  "refreshed_from_jti": "jt_old"
}
```

## Rules

- 只允许刷新尚未过期、且未被撤销的 token
- 新 token 必须保持同一 `sub=user_id` 与 `aud=skill_id`
- 旧 token 允许短暂过渡窗口，便于并发请求平滑切换
- 刷新链必须可追踪 `refreshed_from_jti`

## Failure Codes

- `TOKEN_EXPIRED`
- `TOKEN_REVOKED`
- `TOKEN_INVALID`
