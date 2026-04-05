# Admin Console

## 职责

- 用户、角色、部门查询
- Skill、Agent、Chat 管理
- 策略 CRUD
- 策略模拟测试
- 审计日志查询

## 所属仓库

- `aily-skills-auth-admin-console`

## 技术栈

- React

## Phase 2 冻结范围

- 先冻结管理 API 最小集合，不直接启动前端实现
- 先冻结页面信息架构和导航分组
- 先冻结策略模拟器输入输出模型

## 页面信息架构

- `Overview`
- `Policy Management`
- `Skill / Agent / Chat Registry`
- `Audit Explorer`
- `Policy Simulator`

## 管理 API 最小集合

- 用户、角色、部门查询
- Skill / Agent / Chat 注册表查询
- Policy CRUD
- Policy simulator
- Audit query

## 边界

- 不直接写策略引擎逻辑
- 不直接访问数据库
- 只通过 `iam-service` 管理 API 工作
- Phase 2 不把前端页面实现放到关键路径
