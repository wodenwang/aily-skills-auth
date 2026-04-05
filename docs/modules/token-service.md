# Token Service

## 职责

- 签发短期 JWT
- 刷新 token
- 撤销 token
- 暴露验证所需元数据

## 所属仓库

- `aily-skills-auth-iam-service`

## 固定要求

- `RS256`
- 带 `kid`
- TTL 不超过 5 分钟
- 含 `jti`
- `aud` 绑定 `skill_id`
- `auth_context` 含 `user_id`, `skill_id`, `agent_id`, `chat_id`

## 不负责

- 不在 SDK 侧重复签发
- 不在 CLI 侧保存长期凭据
