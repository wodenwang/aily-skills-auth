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

`0.2.0` 不再把 `agent_id`、`chat_id` 作为缓存键组成部分。

## File Format

```json
{
  "version": 2,
  "entries": [
    {
      "cache_key": "ou_abc123|sales-analysis",
      "user_id": "ou_abc123",
      "skill_id": "sales-analysis",
      "access_token": "eyJ...",
      "token_type": "Bearer",
      "expires_at": "2026-04-06T20:00:00Z",
      "refresh_before_at": "2026-04-06T19:59:00Z",
      "cached_at": "2026-04-06T19:55:00Z",
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
- `user_id` 或 `skill_id` 任一变化时，禁止复用旧缓存项

## Write Rules

- 使用原子写入，避免并发写坏文件
- 缓存文件只保存短期 access token，不保存长期用户凭据
- 不允许在缓存中补充本地推导的权限结果
