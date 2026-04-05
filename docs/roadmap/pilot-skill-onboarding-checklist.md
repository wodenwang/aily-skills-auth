# Pilot Skill Onboarding Checklist

## Goal

为首个真实试点 skill 提供一份直接可执行的接入清单，基于：

- `skill-template`
- `skill-sample`
- `service-demo`
- `authcli`
- `verify-sdk`
- `iam-service`

## Preconditions

- 目标 skill 已有明确 `skill_id`
- 目标 skill 已明确 owner
- 目标 skill 已明确下游业务服务地址
- 目标 skill 所属 Agent 宿主机可安装 `authcli`
- 下游业务服务可接入 `verify-sdk`

## Step 1: Skill Metadata Freeze

- 确认 `skill_id`
- 确认 `skill_name`
- 确认 `owner`
- 确认 `business_purpose`
- 确认 `required_backend_service`

输出：

- 一份基于 [skill-template-spec.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-template-spec.md) 的实际 skill 文档

## Step 2: Runtime Context Freeze

- 明确 `user_id` 来源
- 明确 `agent_id` 来源
- 明确 `chat_id` 来源
- 明确字段缺失时的 fail-closed 规则

## Step 3: AuthCLI Access

- 宿主机安装 `authcli`
- 校验 `auth-cli check --skill <skill_id>` 可执行
- 确认缓存路径可写
- 确认 deny / error 能区分

## Step 4: Service Integration

- 下游服务集成 `verify-sdk`
- 确认请求头透传：
  - `Authorization`
  - `X-Auth-User-ID`
  - `X-Auth-Skill-ID`
  - `X-Auth-Agent-ID`
  - `X-Aily-Chat-Id`
- 确认服务不本地重算策略

## Step 5: Required Validation

- allow 路径通过
- deny 路径通过
- refresh 路径通过
- cross-chat 复用被拒绝
- revoke 后复用被拒绝
- 失败时可查 `request_id`

## Step 6: Pilot Readiness

- 指标已接入
- 告警规则已配置
- 撤销演练可执行
- 缓存失效演练可执行
- 密钥轮换演练步骤已确认
- 回滚步骤已确认

## Exit Criteria

- 该 skill 能稳定复用模板
- 该 skill 已完成真实 E2E
- 该 skill 已具备试点运行条件
