# Token Verify Contract

## Endpoint

- `POST /api/v1/token/verify`

## Request

```json
{
  "token": "eyJ...",
  "user_id": "ou_abc123",
  "skill_id": "sales-analysis",
  "agent_id": "host-vm-a1b2c3d4",
  "chat_id": null
}
```

## Request Semantics

- `chat_id` 是 token verify 的必传上下文字段
- `chat_id = null` 表示当前请求发生在私聊
- `chat_id != null` 表示当前请求发生在群聊，值为当前 chat 标识
- verify 时必须校验当前请求上下文与 token 中 `auth_context` 完全一致
- 最少校验字段为：`user_id`、`skill_id`、`agent_id`、`chat_id`
- token 不允许跨 chat 复用；在 A chat 获取的 token 不可在 B chat 继续使用
- 成功响应结构保持不变

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
- `CHAT_CONTEXT_MISMATCH`
- `AUDIENCE_MISMATCH`
- `SIGNATURE_INVALID`
