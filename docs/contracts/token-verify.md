# Token Verify Contract

## Endpoint

- `POST /api/v1/token/verify`

## Request

```json
{
  "token": "eyJ...",
  "user_id": "ou_abc123",
  "skill_id": "sales-analysis"
}
```

## Request Semantics

- verify 只校验 `user_id` 与 `skill_id`
- IAM 必须校验请求中的 `user_id` 与 token `sub` 一致；不一致时返回 `IDENTITY_MISMATCH`
- IAM 必须校验请求中的 `skill_id` 与 token `aud` 一致；不一致时返回 `AUDIENCE_MISMATCH`
- verify 不重算授权策略，只判断 token 本身是否仍可接受
- 成功响应返回最小鉴权上下文

## Success Response

```json
{
  "valid": true,
  "token_info": {
    "jti": "jt_xxx",
    "user_id": "ou_abc123",
    "skill_id": "sales-analysis"
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
