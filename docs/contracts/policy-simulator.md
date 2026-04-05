# Policy Simulator Contract

## Purpose

冻结 `admin-console` 策略模拟器与 `iam-service` 之间的最小输入输出模型。

## Endpoint

- `POST /api/v1/admin/policies/simulate`

## Request

```json
{
  "user_id": "ou_abc123",
  "skill_id": "sales-analysis",
  "agent_id": "host-vm-a1b2c3d4",
  "chat_id": "oc_sales_weekly"
}
```

## Request Rules

- `chat_id = null` 表示私聊
- 非空 `chat_id` 表示在指定群聊中模拟
- 模拟器只接受显式输入，不推断上下文
- 模拟器调用服务端策略能力，不在前端重算策略

## Success Response

```json
{
  "allowed": true,
  "decision_source": {
    "policy_id": "pol_001",
    "chat_mode": "allowed_list"
  },
  "permissions": ["sales:read"],
  "data_scope": {
    "data_level": "department",
    "dept_ids": ["D001"]
  },
  "explanation": [
    "user has at least one allowed role",
    "chat is in allowlist"
  ]
}
```

## Denied Response

```json
{
  "allowed": false,
  "deny_code": "CHAT_SKILL_DENIED",
  "decision_source": {
    "policy_id": "pol_001",
    "chat_mode": "allowed_list"
  },
  "explanation": [
    "chat is not in allowlist"
  ]
}
```

## UI Boundary

- `admin-console` 只展示服务端返回的判定依据
- `admin-console` 不内嵌本地策略解释器
- 模拟器结果应能直接映射到审计和真实鉴权错误码
