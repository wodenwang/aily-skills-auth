# Admin Management API

## Purpose

冻结 `admin-console` 在 `0.2.0` MVP 依赖的最小管理 API 集合，避免前端启动后再反向推动接口设计。

## `0.2.0` Rule

- 本文档冻结接口集合与语义
- `admin-console` MVP 只围绕 `users`、`skills`、`grants`、`audit-logs`
- 前端实现不得先于本文档新增未冻结接口

## Resource Groups

### Users

- `GET /api/v1/admin/users`
- `GET /api/v1/admin/users/{user_id}`
- `PUT /api/v1/admin/users/{user_id}`

最小字段：

- `user_id`
- `name`
- `email`
- `status`
- `updated_at`
- `updated_by`

### Skills

- `GET /api/v1/admin/skills`
- `GET /api/v1/admin/skills/{skill_id}`
- `POST /api/v1/admin/skills`
- `PUT /api/v1/admin/skills/{skill_id}`

最小字段：

- `skill_id`
- `skill_name`
- `description`
- `status`
- `updated_at`
- `updated_by`

### Grants

- `GET /api/v1/admin/grants`
- `POST /api/v1/admin/grants`
- `GET /api/v1/admin/grants/{grant_id}`
- `PUT /api/v1/admin/grants/{grant_id}`
- `DELETE /api/v1/admin/grants/{grant_id}`

最小字段：

- `grant_id`
- `user_id`
- `skill_id`
- `status`
- `effective_at`
- `expires_at`
- `reason`
- `updated_at`
- `updated_by`

### Audit Logs

- `GET /api/v1/admin/audit-logs`
- `GET /api/v1/admin/audit-logs/{request_id}`

最小返回字段：

- `request_id`
- `audit_type`
- `user_id`
- `skill_id`
- `decision`
- `deny_code`
- `operator_id`
- `created_at`
- `latency_ms`

最小过滤条件：

- `request_id`
- `user_id`
- `skill_id`
- `decision`
- `deny_code`
- `time_range`

## Read / Write Boundary

- `Users`：必须支持查询与资料更新
- `Skills`：必须支持查询与维护
- `Grants`：是 `0.2.0` 的核心写接口组
- `Audit Logs`：只读
- `admin-console` 不允许直接访问数据库

审计口径：

- `audit-logs` 是统一审计视图
- 通过 `audit_type` 区分 `auth_check`、`token_verify`、`admin_operation`

## Shared Response Rules

- 列表接口返回 `items` 数组和 `next_cursor`
- 详情接口返回单资源对象
- 写接口必须返回最新资源视图
- 错误码沿用上游冻结集合，新增管理侧错误码前必须先回写主控仓
