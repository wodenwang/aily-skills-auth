# Security Cases

## 必测安全场景

- 伪造 `user_id` 与 token `sub` 不一致
- 伪造 `skill_id` 与 token `aud` 不一致
- 使用过期 token
- 使用已撤销 token
- 在 chat A 获取 token 后拿到 chat B 复用
- 使用白名单外群聊请求敏感 Skill
- IAM 网关不可用时 `authcli` fail-closed
- 日志中不输出完整 token

## 告警要求

- `IDENTITY_MISMATCH` 立即告警
- `CHAT_CONTEXT_MISMATCH` 立即告警
- 异常撤销频率告警
- 鉴权拒绝率异常告警
