# Repo Topology

以下图用于说明主控仓与各子仓在 `0.2.0` 的固定关系。

```mermaid
flowchart LR
  control["aily-skills-auth\n主控规划仓"]
  iam["aily-skills-auth-iam-service\n鉴权决策 / Token / 审计 / 管理 API"]
  cli["aily-skills-auth-authcli\n本地鉴权 CLI / 缓存 / 刷新"]
  sdk["aily-skills-auth-verify-sdk\n服务端 Token 验证 SDK"]
  demo["aily-skills-auth-demo-skill\nskill-template / skill-sample / service-demo"]
  admin["aily-skills-auth-admin-console\n用户 / Skill / Grant / Audit 管理台"]

  control -->|冻结契约与任务书| iam
  control -->|冻结契约与任务书| cli
  control -->|冻结契约与任务书| sdk
  control -->|冻结契约与任务书| demo
  control -->|冻结契约与任务书| admin
  cli -->|POST /api/v1/auth/check| iam
  sdk -->|POST /api/v1/token/verify| iam
  demo -->|使用| cli
  demo -->|接入| sdk
  admin -->|调用管理 API| iam
```

说明：

- `authcli` 与 `verify-sdk` 都只依赖 `iam-service`
- `demo-skill` 不直接接入数据库或管理 API
- `admin-console` 在 `0.2.0` 的目标是 `Users`、`Skills`、`Grants`、`Audit` 四类管理能力
