# Acceptance Matrix

| 场景 | 期望 | 责任仓 |
|------|------|--------|
| 私聊允许，群聊拒绝 | 私聊 allow，群聊 deny | `iam-service`, `authcli` |
| 白名单群允许，随机群拒绝 | 群策略生效 | `iam-service`, `authcli` |
| 角色允许但群策略拒绝 | 群策略优先拒绝 | `iam-service` |
| token 即将过期 | 自动刷新 | `authcli`, `iam-service` |
| token 已过期 | 完整重新鉴权 | `authcli`, `iam-service` |
| 身份头与 token 不一致 | `IDENTITY_MISMATCH` | `verify-sdk` |
| token 在原 chat 验证通过，在其他 chat 验证失败 | `CHAT_CONTEXT_MISMATCH` | `iam-service`, `verify-sdk` |
| token 被撤销 | 缓存立即失效 | `iam-service`, `verify-sdk` |
| `service-demo` 收到已撤销 token | 服务端立即拒绝 | `demo-skill`, `verify-sdk`, `iam-service` |
| `service-demo` 收到过期 token | 服务端拒绝并触发重新鉴权路径 | `demo-skill`, `verify-sdk`, `authcli`, `iam-service` |
| 飞书用户离职 | 鉴权失败 | `iam-service`, `feishu-sync` |

## 固定测试类型

- 领域规则测试
- 契约测试
- CLI 行为测试
- SDK 集成测试
- E2E 测试
