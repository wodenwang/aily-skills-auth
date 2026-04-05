# Admin Management API

## Purpose

冻结 `admin-console` 在 Phase 2 依赖的最小管理 API 集合，避免前端启动后再反向推动接口设计。

## Phase 2 Rule

- 本文档冻结接口集合与语义
- Phase 2 不要求这些接口全部实现完成
- 前端实现不得先于本文档新增未冻结接口

## Resource Groups

### Identity Query

- `GET /api/v1/admin/users`
- `GET /api/v1/admin/users/{user_id}`
- `GET /api/v1/admin/roles`
- `GET /api/v1/admin/departments`

语义：

- 只用于查询，不承载策略写入
- `user_id` 固定使用飞书 `open_id`

### Registry Query

- `GET /api/v1/admin/skills`
- `GET /api/v1/admin/agents`
- `GET /api/v1/admin/chats`

语义：

- 用于渲染 `Skill / Agent / Chat Registry`
- Phase 2 先冻结读接口，写接口不作为首轮阻塞项

### Policy CRUD

- `GET /api/v1/admin/policies`
- `POST /api/v1/admin/policies`
- `GET /api/v1/admin/policies/{policy_id}`
- `PUT /api/v1/admin/policies/{policy_id}`
- `DELETE /api/v1/admin/policies/{policy_id}`

最小字段：

- `policy_id`
- `skill_id`
- `role_ids`
- `chat_mode`
- `allowed_chat_ids`
- `data_scope`
- `status`
- `updated_at`
- `updated_by`

### Audit Query

- `GET /api/v1/admin/audit-logs`
- `GET /api/v1/admin/audit-logs/{request_id}`

最小过滤条件：

- `request_id`
- `user_id`
- `skill_id`
- `agent_id`
- `chat_id`
- `decision`
- `deny_code`
- `time_range`

## Read / Write Boundary

- Phase 2 必须支持查询接口
- `Policy CRUD` 是唯一必须冻结的写接口组
- `Skill / Agent / Chat` 的写接口延后，不纳入本轮阻塞
- `admin-console` 不允许直接访问数据库

## Shared Response Rules

- 列表接口返回 `items` 数组和 `next_cursor`
- 详情接口返回单资源对象
- 写接口必须返回最新资源视图
- 错误码沿用上游冻结集合，新增管理侧错误码前必须先回写主控仓
