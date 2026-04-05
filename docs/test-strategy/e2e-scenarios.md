# End To End Scenarios

## Scenario 1: Private Chat Success

1. 飞书同步存在有效用户
2. Agent 触发私聊 Skill
3. AuthCLI 成功获取 token
4. Skill 调用后端 API
5. Verify SDK 验证通过
6. 返回受限数据

## Scenario 2: Group Deny

1. 用户在未授权群中调用 Skill
2. AuthCLI 请求 `/auth/check`
3. IAM 返回 `CHAT_SKILL_DENIED`
4. Skill 不调用数据 API

## Scenario 3: Refresh And Retry

1. AuthCLI 命中即将过期 token
2. AuthCLI 请求 `/token/refresh`
3. 刷新成功并更新缓存
4. 后续调用继续成功

## Scenario 4: Revoked Token

1. 管理员撤销 token
2. `service-demo` 通过 Verify SDK 收到请求
3. 校验失败并拒绝
4. 客户端重新鉴权

## Scenario 5: Cross Chat Token Reuse Denied

1. 用户在 chat A 中调用 Skill
2. AuthCLI 基于 chat A 上下文成功获取 token
3. `skill-sample` 在 chat A 调用 `service-demo`，Verify SDK 验证通过
4. 同一 token 被带到 chat B 再次调用 `service-demo`
5. Verify SDK 把 chat B 的 `chat_id` 传给 `/api/v1/token/verify`
6. IAM 发现请求上下文与 token `auth_context.chat_id` 不一致
7. 返回 `CHAT_CONTEXT_MISMATCH` 并拒绝请求

## Scenario 6: Revoked Token Rejected By Protected API

1. 用户先通过 `authcli` 获取 token
2. `skill-sample` 携带 token 调用 `service-demo`，Verify SDK 验证通过
3. 运维或测试工具调用 `/api/v1/token/revoke`
4. `skill-sample` 再次复用旧 token 调用 `service-demo`
5. Verify SDK 调用 `/api/v1/token/verify`
6. IAM 返回 `TOKEN_REVOKED`
7. API 立即拒绝，客户端必须重新鉴权
