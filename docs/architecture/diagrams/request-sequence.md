# Request Sequence

以下图用于说明 `0.2.0` 的标准调用链路。

```mermaid
sequenceDiagram
  participant Agent
  participant AuthCLI as authcli
  participant IAM as iam-service
  participant SkillService as service-demo
  participant VerifySDK as verify-sdk

  Agent->>AuthCLI: auth-cli check --skill <skill_id> --user-id <user_id>
  alt cache hit and token still valid
    AuthCLI-->>Agent: cached access_token
  else cache miss or needs refresh
    AuthCLI->>IAM: POST /api/v1/auth/check
    IAM-->>AuthCLI: allowed + access_token
    AuthCLI-->>Agent: access_token
  end

  Agent->>SkillService: business request + Authorization + X-Auth-User-ID + X-Auth-Skill-ID
  SkillService->>VerifySDK: verify incoming token
  VerifySDK->>IAM: POST /api/v1/token/verify
  IAM-->>VerifySDK: valid token for user_id + skill_id
  VerifySDK-->>SkillService: verified auth context
  SkillService-->>Agent: protected business response
```

固定语义：

- 所有关键服务调用前，必须先执行 `auth-cli check`
- 所有关键服务调用必须携带 `Authorization: Bearer <access_token>`
- 服务端不重算授权策略，只通过 `verify-sdk` 调 `iam-service` 做 token 验证
