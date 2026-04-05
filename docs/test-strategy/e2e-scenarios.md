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
2. Verify SDK 收到请求
3. 校验失败并拒绝
4. 客户端重新鉴权
