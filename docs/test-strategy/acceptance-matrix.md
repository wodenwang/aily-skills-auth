# Acceptance Matrix

| 场景 | 期望 | 责任仓 |
|------|------|--------|
| 存在有效授权绑定 | allow 并签发 token | `iam-service`, `authcli` |
| 不存在授权绑定 | deny | `iam-service`, `authcli` |
| 授权状态为 `inactive` | deny | `iam-service` |
| 授权状态为 `revoked` | deny | `iam-service` |
| 授权尚未生效 | `GRANT_NOT_YET_EFFECTIVE` | `iam-service` |
| 授权已过期 | `GRANT_EXPIRED` | `iam-service` |
| token 即将过期 | 自动刷新 | `authcli`, `iam-service` |
| token 已过期 | 完整重新鉴权 | `authcli`, `iam-service` |
| 身份头与 token 不一致 | `IDENTITY_MISMATCH` | `verify-sdk`, `iam-service` |
| token 被撤销 | 缓存立即失效 | `iam-service`, `verify-sdk`, `authcli` |
| `service-demo` 收到已撤销 token | 服务端立即拒绝 | `demo-skill`, `verify-sdk`, `iam-service` |
| `service-demo` 收到过期 token | 服务端拒绝并触发重新鉴权路径 | `demo-skill`, `verify-sdk`, `authcli`, `iam-service` |
| Skill 模板调用关键服务 | 标准头完整 | `demo-skill`, `verify-sdk` |
| Admin Console 维护用户资料 | 管理 API 与页面流程一致 | `admin-console`, `iam-service` |
| Admin Console 维护 Skill | 管理 API 与页面流程一致 | `admin-console`, `iam-service` |
| Admin Console 管理授权绑定 | `grant` CRUD 与时效字段稳定 | `admin-console`, `iam-service` |
| Admin Console 查询审计日志 | 支持按用户、技能、时间范围查询 | `admin-console`, `iam-service` |
| `auth-cli check --help` | 帮助文案完整且稳定 | `authcli` |

## 固定测试类型

- 领域规则测试
- 契约测试
- CLI 行为测试
- SDK 集成测试
- E2E 测试
- 管理台流程测试
