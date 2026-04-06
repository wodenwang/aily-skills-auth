# Security Cases

## 必测安全场景

- 伪造 `user_id` 与 token `sub` 不一致
- 伪造 `skill_id` 与 token `aud` 不一致
- 使用过期 token
- 使用已撤销 token
- 未获得授权绑定时尝试调用敏感 Skill
- 使用 `inactive` 或 `revoked` 授权记录尝试获取 token
- IAM 网关不可用时 `authcli` fail-closed
- 日志中不输出完整 token

## 告警要求

- `IDENTITY_MISMATCH` 立即告警
- 异常撤销频率告警
- 鉴权拒绝率异常告警
- 管理操作异常频率告警
