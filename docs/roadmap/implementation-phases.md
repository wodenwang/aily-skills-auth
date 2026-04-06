# Implementation Phases

## Current State

- `0.1.0-alpha` 已完成 MVP 验证
- 当前阶段进入 `0.2.0` 规格收敛
- 本轮先更新主控仓规划、契约、模板与任务书

## Phase 0: Freeze

- 完成 V3.1 主文档
- 冻结注册表、契约、测试矩阵
- 建立 `0.2.0` 子仓任务书

## Phase 1: `0.1.0-alpha` MVP Closed Loop

- `iam-service`: 最小鉴权、JWT、审计
- `authcli`: 身份采集、缓存、鉴权调用、失败关闭
- `verify-sdk`: token 验证与身份一致性校验
- `demo-skill`: 最小 `skill-template + skill-sample + service-demo` 样板

交付结果：

- 最小闭环已验证成功
- 可进入模型收敛与下一阶段规划

## Phase 2: `0.2.0` Spec Convergence

- `iam-service`: 领域模型收敛到 `User`、`Skill`、`UserSkillGrant`、`AuditLog`
- `authcli`: 命令面、缓存键、帮助文案按最小模型重冻
- `verify-sdk`: 对齐最小 token 契约
- `demo-skill`: 拆分 `skill-template` 与 `service-demo` 样板职责
- `admin-console`: 启动 MVP 规格与管理 API 冻结

交付标准：

- 所有主文档和契约移除 `chat/agent/role/group/department` 授权依赖
- Admin API 完成 `users`、`skills`、`grants`、`audit-logs` 冻结
- Demo Skill 模板可直接指导子仓实施

## Phase 3: Subproject Implementation

- 各子仓按 `0.2.0` 任务书落地实现
- `iam-service` 与 `admin-console` 并行推进
- `authcli`、`verify-sdk`、`demo-skill` 同步跟进公共契约变更

交付标准：

- 子仓实现与主控仓文档一致
- 联调不再依赖旧模型字段
- 管理台 MVP 可支撑基本运营

## Phase 4: Pilot And Productionization

- 试点 Skill 接入
- 监控告警
- 密钥管理与轮换
- 归档和运维手册

交付标准：

- 首批部门可稳定使用
- 关键安全告警可观测
- 生产部署与回滚可演练
