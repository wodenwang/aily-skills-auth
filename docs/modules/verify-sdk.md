# Verify SDK

## 职责

- 验证 JWT
- 校验身份一致性
- 缓存验证结果
- 处理撤销传播
- 向业务服务注入鉴权上下文

## 所属仓库

- `aily-skills-auth-verify-sdk`

## 首版范围

- Python SDK / 中间件
- 面向 FastAPI 优先，Flask 兼容不作为首轮阻塞项
- 只做远程 verify，不做本地策略和离线验签旁路

## 核心约束

- 不重算策略
- 必须把当前请求的 `chat_id` 传给 IAM Service `POST /api/v1/token/verify`
- 必须校验 token 与当前请求上下文是否一致
- 上下文一致性最少包含 `user_id`、`skill_id`、`agent_id`、`chat_id`
- 不允许在 A chat 获取的 token 在 B chat 中继续使用
- `IDENTITY_MISMATCH` 必须可审计、可告警
- `CHAT_CONTEXT_MISMATCH` 必须可审计、可告警

## 标准输入口径

- `Authorization: Bearer <token>`
- `X-Auth-User-ID`
- `X-Auth-Skill-ID`
- `X-Auth-Agent-ID`
- `X-Aily-Chat-Id`，或等价 `chat_id`

## chat_id 归一化

- 业务显式传入的 `chat_id` 优先
- 标准 header 次之
- 缺失、空字符串、全空白统一归一化为 `null`
- SDK 不允许自行猜测群聊 ID

## 默认失败处理

- `TOKEN_REVOKED`：立即拒绝
- `IDENTITY_MISMATCH`：立即拒绝并记录告警
- `CHAT_CONTEXT_MISMATCH`：立即拒绝并记录告警
- `TOKEN_EXPIRED`：返回标准拒绝结果，由调用方决定是否重新走 `authcli`
