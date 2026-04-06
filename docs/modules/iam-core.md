# IAM Core

## 职责

- 管理用户资料
- 管理 Skill 注册信息
- 管理用户与 Skill 的授权绑定
- 提供管理 API
- 维护鉴权、验证、管理操作审计

## 所属仓库

- `aily-skills-auth-iam-service`

## 输入

- 管理员配置
- 鉴权请求
- token verify 请求
- 用户资料维护请求

## 输出

- 用户视图
- Skill 管理数据
- UserSkillGrant 管理数据
- 审计日志查询能力

## `0.2.0` 运行语义

- Skill 处于 `inactive` 时，IAM 必须拒绝新的鉴权请求
- `audit_logs` 采用统一审计视图，通过 `audit_type` 区分鉴权、验证、管理操作

## `0.2.0` 数据模型目标

- `users`
- `skills`
- `user_skill_grants`
- `audit_logs`

## 边界

- 不负责 CLI 本地缓存
- 不负责服务端 verify 中间件实现
- 不负责前端页面渲染
- 不把 `role`、`group`、`department`、`chat`、`agent` 作为授权主模型
