# Policy Engine

## 职责

- 评估 `user_id + skill_id` 授权绑定
- 执行状态与时间窗口判定
- 输出允许/拒绝结果

## 所属仓库

- `aily-skills-auth-iam-service`

## 输入

- `user_id`
- `skill_id`
- 当前时间
- Skill 状态
- 活跃授权绑定记录

## 输出

- `allowed`
- `deny_code`

## 规则

- 安全默认拒绝
- `Skill.status != active` 时优先拒绝
- 未命中授权绑定时拒绝
- 只有 `status=active` 才允许继续判断
- `effective_at` 未到时拒绝
- `expires_at` 已过时拒绝
- `inactive` 与 `revoked` 都优先拒绝

## 非目标

- 不评估 `chat`
- 不评估 `agent`
- 不评估 `role` 或 `group`
- 不输出 `permissions` 或 `data_scope`
