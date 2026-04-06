# End To End Scenarios

## Scenario 1: Allow With Active Grant

1. IAM 中存在有效的 `user_id + skill_id` 授权绑定
2. Agent 触发 Skill
3. AuthCLI 成功获取 token
4. Skill 调用后端 API
5. Verify SDK 验证通过
6. 返回业务结果

## Scenario 2: Deny Without Grant

1. 用户未获得某 Skill 授权
2. AuthCLI 请求 `/api/v1/auth/check`
3. IAM 返回 `GRANT_NOT_FOUND` 或 `GRANT_NOT_ACTIVE`
4. Skill 不调用关键服务

## Scenario 3: Refresh And Retry

1. AuthCLI 命中即将过期 token
2. AuthCLI 请求 `/api/v1/token/refresh`
3. 刷新成功并更新缓存
4. 后续调用继续成功

## Scenario 4: Revoked Token

1. 用户先通过 `authcli` 获取 token
2. 管理员或系统撤销该 token
3. `service-demo` 通过 Verify SDK 收到请求
4. 校验失败并拒绝
5. 客户端重新鉴权

## Scenario 5: Identity Mismatch Rejected

1. 用户先通过 `authcli` 获取 token
2. `skill-sample` 调用 `service-demo`
3. 请求头中的 `X-Auth-User-ID` 或 `X-Auth-Skill-ID` 被错误修改
4. Verify SDK 调用 `/api/v1/token/verify`
5. IAM 发现请求中的 `user_id` 或 `skill_id` 与 token `sub/aud` 不一致
6. 返回 `IDENTITY_MISMATCH`
7. API 立即拒绝请求

## Scenario 6: Revoked Token Rejected By Protected API

1. 用户先通过 `authcli` 获取 token
2. `skill-sample` 携带 token 调用 `service-demo`，Verify SDK 验证通过
3. 运维或测试工具调用撤销接口
4. `skill-sample` 再次复用旧 token 调用 `service-demo`
5. Verify SDK 调用 `/api/v1/token/verify`
6. IAM 返回 `TOKEN_REVOKED`
7. API 立即拒绝，客户端必须重新鉴权
