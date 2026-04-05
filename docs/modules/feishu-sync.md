# Feishu Sync

## 职责

- 同步用户与部门
- 对接用户状态变化
- 为 IAM 提供身份基础数据

## 所属仓库

- `aily-skills-auth-iam-service`

## 数据源

- 飞书 Open API

## 同步策略

- POC：定时拉取
- Pilot/Production：定时拉取 + 事件订阅

## 边界

- 不管理业务角色定义
- 不直接签发 token
- 不替代审计系统
