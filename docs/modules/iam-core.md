# IAM Core

## 职责

- 管理用户、部门、角色
- 管理 Skill、Agent、Chat 注册信息
- 提供管理 API
- 维护审计记录

## 所属仓库

- `aily-skills-auth-iam-service`

## 输入

- 飞书同步数据
- 管理员配置
- 子系统注册请求

## 输出

- 用户/角色/部门视图
- Skill/Agent/Chat 管理数据
- 审计日志查询能力

## 边界

- 不负责 CLI 本地缓存
- 不负责服务端 verify 中间件实现
- 不负责前端页面渲染
