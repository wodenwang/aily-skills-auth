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

## 边界

- 不直接写策略引擎逻辑
- 不直接访问数据库
- 只通过 `iam-service` 管理 API 工作
