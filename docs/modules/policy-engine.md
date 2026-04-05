# Policy Engine

## 职责

- 评估五维权限模型
- 执行群策略三态
- 输出允许/拒绝与数据范围

## 所属仓库

- `aily-skills-auth-iam-service`

## 输入

- `user`
- `agent`
- `skill`
- `chat`
- `context`
- 活跃策略集

## 输出

- `allowed`
- `deny_code`
- `permissions`
- `data_scope`

## 规则

- 安全默认拒绝
- deny 优先于 allow
- 匹配策略按优先级评估
- 群策略只控制群中是否允许
- 角色/部门/用户条件和时间窗口同时生效
