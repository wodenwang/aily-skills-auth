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
- `sub` 绑定 `user_id`
- `aud` 绑定 `skill_id`
- 最小 claims，不再包含 `chat_id`、`agent_id`、`permissions`、`data_scope`

## 运行约束

- 刷新后的 token 必须保持相同 `sub` 与 `aud`
- 撤销判定必须支持按 `jti` 追踪
- `verify-sdk` 只消费验证结果，不重复签发

## 不负责

- 不在 SDK 侧重复签发
- 不在 CLI 侧保存长期凭据
