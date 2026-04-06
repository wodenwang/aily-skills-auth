# Domain Model

## Identity Tuple

`0.2.0` 固定最小身份字段：

- `user_id`
- `skill_id`

其中：

- `user_id` 使用飞书 `open_id`
- `skill_id` 是平台注册技能的稳定标识
- `agent_id`、`chat_id`、`appid` 不再作为公共契约中的授权字段

verify 的上下文一致性最少包含：

- `user_id`
- `skill_id`

## Authorization Dimensions

`0.2.0` 只保留两维授权模型：

- `user`
- `skill`

以下能力不纳入本轮授权决策：

- `agent`
- `chat`
- `role`
- `group`
- `department`
- `data_scope`

## Core Resources

### User

- `user_id`
- `name`
- `email`
- `status`
- `created_at`
- `updated_at`

### Skill

- `skill_id`
- `skill_name`
- `description`
- `status`
- `created_at`
- `updated_at`

`status` 至少包含：

- `active`
- `inactive`

语义：

- `inactive` 的 Skill 在 `0.2.0` 中必须被视为不可签发 token

### UserSkillGrant

- `grant_id`
- `user_id`
- `skill_id`
- `status`
- `effective_at`
- `expires_at`
- `updated_at`
- `updated_by`
- `reason`

`status` 至少包含：

- `active`
- `inactive`
- `revoked`

## JWT Claims

```json
{
  "iss": "auth.company.internal",
  "sub": "ou_xxx",
  "aud": "sales-analysis",
  "iat": 1775424000,
  "exp": 1775424300,
  "jti": "jt_xxx"
}
```

说明：

- `sub` 是 `user_id`
- `aud` 是 `skill_id`
- `jti` 用于撤销与刷新追踪
- 不再包含 `auth_context`、`permissions`、`data_scope`

## Decision Rules

- 当 `Skill.status != active` 时必须默认拒绝
- 当存在匹配的 `UserSkillGrant` 且 `status=active` 时，才允许继续判断时间窗口
- `effective_at` 未到时必须拒绝
- `expires_at` 已过时必须拒绝
- `inactive` 与 `revoked` 都必须拒绝
- 未命中任何授权绑定时必须默认拒绝

## Audit Minimum Fields

- `audit_type`
- `request_id`
- `user_id`
- `skill_id`
- `decision`
- `deny_code`
- `latency_ms`
- `operator_id`
- `created_at`

说明：

- `audit_type` 至少区分 `auth_check`、`token_verify`、`admin_operation`
- `operator_id` 只在管理操作审计中出现；鉴权与验证请求可为空
