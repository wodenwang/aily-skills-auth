# Auth Check Contract

## Endpoint

- `POST /api/v1/auth/check`

## Request

```json
{
  "user_id": "ou_abc123",
  "skill_id": "sales-analysis",
  "context": {
    "requested_action": "read",
    "trace_id": "trace_123"
  }
}
```

## Request Semantics

- `user_id` 与 `skill_id` 是唯一强约束字段
- `context` 只作为审计和业务扩展透传，不参与 `0.2.0` 授权决策
- IAM 必须先检查 `Skill.status`
- IAM 必须基于 `UserSkillGrant` 的存在性、`status`、生效时间、失效时间做决策

## Success Response

```json
{
  "request_id": "req_abc123",
  "allowed": true,
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 300,
  "refresh_before": 240,
  "cache_ttl": 280
}
```

## Denied Response

```json
{
  "request_id": "req_abc123",
  "allowed": false,
  "deny_code": "GRANT_NOT_ACTIVE",
  "deny_message": "该用户当前未获得此 Skill 的有效授权"
}
```

## Error Codes

- `PERMISSION_DENIED`
- `USER_NOT_FOUND`
- `SKILL_NOT_FOUND`
- `SKILL_INACTIVE`
- `GRANT_NOT_FOUND`
- `GRANT_NOT_ACTIVE`
- `GRANT_NOT_YET_EFFECTIVE`
- `GRANT_EXPIRED`
- `RATE_LIMITED`
- `GATEWAY_UNAVAILABLE`
