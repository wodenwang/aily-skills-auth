# Domain Model

## Identity Tuple

固定身份字段：

- `user_id`
- `skill_id`
- `agent_id`
- `chat_id`

其中：

- `chat_id` 是 token verify 的必传上下文字段之一
- 私聊场景下 `chat_id` 传 `null`
- `user_id` 使用飞书 `open_id`
- `agent_id` 必须稳定且唯一

verify 的上下文一致性最少包含：

- `user_id`
- `skill_id`
- `agent_id`
- `chat_id`

## Authorization Dimensions

- `user`
- `agent`
- `chat`
- `skill`
- `data_scope`

## JWT Claims

```json
{
  "iss": "auth.company.internal",
  "sub": "ou_xxx",
  "aud": "sales-analysis",
  "iat": 1743761880,
  "exp": 1743762180,
  "jti": "jt_xxx",
  "auth_context": {
    "user_id": "ou_xxx",
    "skill_id": "sales-analysis",
    "agent_id": "host-vm-a1b2c3d4",
    "chat_id": "oc_xxx"
  },
  "permissions": ["sales:read"],
  "data_scope": {
    "data_level": "department",
    "dept_ids": ["D001"]
  }
}
```

说明：

- `auth_context.chat_id` 是 token 绑定上下文的一部分，不只是审计字段
- token verify 时必须校验请求中的 `user_id + skill_id + agent_id + chat_id` 与 `auth_context` 一致

## Audit Minimum Fields

- `request_id`
- `user_id`
- `skill_id`
- `agent_id`
- `chat_id`
- `allowed`
- `deny_code`
- `latency_ms`
