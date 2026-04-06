# Feishu Sync

## 状态

- `0.2.0` future / deferred

## 说明

飞书组织架构与通讯录同步不纳入 `0.2.0` 主路径。

当前 IAM 最小模型只要求：

- `user_id`
- 用户资料维护
- Skill 注册
- UserSkillGrant 管理

后续若重新引入飞书同步，应另行冻结：

- 同步边界
- 用户资料覆盖规则
- 离职与禁用语义
- 事件与定时任务策略

## 当前边界

- 不作为 `iam-service` 的当前模块职责
- 不进入 `0.2.0` 验收矩阵
- 不阻塞 `admin-console`、`authcli`、`verify-sdk`、`demo-skill` 实施
