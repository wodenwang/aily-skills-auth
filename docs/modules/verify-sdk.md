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
- 面向 FastAPI/Flask 类后端优先

## 核心约束

- 不重算策略
- 必须校验 token 与请求头身份是否一致
- `IDENTITY_MISMATCH` 必须可审计、可告警
