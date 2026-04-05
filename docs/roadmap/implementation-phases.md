# Implementation Phases

## Phase 0: Freeze

- 完成 V3 主文档
- 冻结注册表、契约、测试矩阵
- 建立子仓创建顺序和 owner 规则

## Phase 1: IAM Service + AuthCLI MVP

- `iam-service`: 用户/角色/部门、策略引擎、JWT、审计、飞书同步
- `authcli`: 身份采集、缓存、鉴权调用、失败关闭
- `demo-skill`: 最小端到端链路

交付标准：

- 支持私聊和群聊的最小鉴权链路
- 支持 token 发放、过期、刷新
- 支持审计落库

## Phase 2: Verify SDK + Admin Console

- `verify-sdk`: token 验证、身份一致性校验、缓存、撤销
- `admin-console`: 用户、角色、策略、Skill、Agent、审计、模拟器

交付标准：

- 后端 API 能强制验证 token
- 策略配置和模拟测试可视化
- 群策略可运营

## Phase 3: Pilot And Productionization

- 试点 Skill 接入
- 监控告警
- 密钥管理与轮换
- 归档和运维手册

交付标准：

- 首批部门可稳定使用
- 关键安全告警可观测
- 生产部署与回滚可演练
