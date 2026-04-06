# Admin Console

## 职责

- 用户查询与维护
- Skill 查询与维护
- UserSkillGrant 管理
- 审计日志查询

## 所属仓库

- `aily-skills-auth-admin-console`

## 技术栈

- React

## `0.2.0` 定位

- 从“最后再做”调整为 `0.2.0` 开始实现的 MVP 子项目
- 以前置冻结的管理 API 为唯一后端依赖
- 目标是支撑可运营管理，不引入复杂策略系统

## MVP 页面信息架构

- `Users`
- `Skills`
- `Grants`
- `Audit`

## MVP 流程

### Users

- 查询用户
- 查看用户详情
- 维护姓名、邮箱等资料

### Skills

- 查询技能
- 查看技能详情
- 维护技能基础注册信息

### Grants

- 查询授权记录
- 创建用户-Skill 授权
- 修改状态、生效时间、失效时间
- 撤销授权

### Audit

- 按用户、技能、时间范围、`decision` 查询审计日志
- 查看单条请求或操作详情

## 本版本不纳入

- 角色管理
- 组织架构浏览
- 群聊策略
- 策略模拟器
- 批量导入
- 复杂数据范围配置

## 管理 API 最小集合

- `GET /api/v1/admin/users`
- `GET /api/v1/admin/users/{user_id}`
- `PUT /api/v1/admin/users/{user_id}`
- `GET /api/v1/admin/skills`
- `GET /api/v1/admin/skills/{skill_id}`
- `POST /api/v1/admin/skills`
- `PUT /api/v1/admin/skills/{skill_id}`
- `GET /api/v1/admin/grants`
- `GET /api/v1/admin/grants/{grant_id}`
- `POST /api/v1/admin/grants`
- `PUT /api/v1/admin/grants/{grant_id}`
- `DELETE /api/v1/admin/grants/{grant_id}`
- `GET /api/v1/admin/audit-logs`
- `GET /api/v1/admin/audit-logs/{request_id}`

## 边界

- 不直接写策略引擎逻辑
- 不直接访问数据库
- 只通过 `iam-service` 管理 API 工作
