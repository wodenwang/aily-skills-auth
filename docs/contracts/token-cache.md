# Token Cache Contract

## Purpose

冻结 `authcli` 的本地 token 缓存文件格式与失效规则，避免后续 CLI 行为漂移。

## File Location

- 默认路径：`~/.aily-skills-auth/cache/tokens.json`
- 支持通过配置覆盖，但文件内容结构必须保持一致

## Cache Key

缓存键固定由以下字段拼接：

- `user_id`
- `skill_id`
- `agent_id`
- `chat_id`

私聊场景下 `chat_id` 固定写为 `null`。

## File Format

```json
{
  "version": 1,
  "entries": [
    {
      "cache_key": "ou_abc123|sales-analysis|host-vm-a1b2c3d4|oc_sales_weekly",
      "user_id": "ou_abc123",
      "skill_id": "sales-analysis",
      "agent_id": "host-vm-a1b2c3d4",
      "chat_id": "oc_sales_weekly",
      "access_token": "eyJ...",
      "token_type": "Bearer",
      "expires_at": "2026-04-05T20:00:00Z",
      "refresh_before_at": "2026-04-05T19:59:00Z",
      "cached_at": "2026-04-05T19:55:00Z",
      "source": "auth_check"
    }
  ]
}
```

## Invalidation Rules

- 当前时间早于 `refresh_before_at` 时，允许直接命中缓存
- 当前时间大于等于 `refresh_before_at` 且早于 `expires_at` 时，必须先调用 `/api/v1/token/refresh`
- 当前时间大于等于 `expires_at` 时，禁止刷新旧 token，必须重新调用 `/api/v1/auth/check`
- 上游返回 `TOKEN_REVOKED`、`TOKEN_INVALID`、`TOKEN_EXPIRED` 时，必须立即删除对应缓存项
- 请求上下文四元组任一字段变化时，禁止复用旧缓存项

## Write Rules

- 使用原子写入，避免并发写坏文件
- 缓存文件只保存短期 access token，不保存长期用户凭据
- 不允许在缓存中补充本地推导的权限结果
