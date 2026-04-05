# Implementation Phases

## Phase 0: Freeze

- 完成 V3 主文档
- 冻结注册表、契约、测试矩阵
- 建立子仓创建顺序和 owner 规则

## Phase 1: IAM Service + AuthCLI MVP

- `iam-service`: 用户/角色/部门、策略引擎、JWT、审计、飞书同步
- `authcli`: 身份采集、缓存、鉴权调用、失败关闭
- `demo-skill`: 最小 `skill-template + skill-sample + service-demo` 样板

交付标准：

- 支持私聊和群聊的最小鉴权链路
- 支持 token 发放、过期、刷新
- 支持审计落库

## Phase 2: Verify SDK + Demo Skill

- `verify-sdk`: token 验证、身份一致性校验、标准错误映射
- `demo-skill`: 完整 `skill-sample -> service-demo -> verify-sdk -> iam-service` E2E 样板

交付标准：

- 后端 API 能强制验证 token
- 跨 chat 复用和 revoke 后复用被稳定拒绝

当前状态：

- `iam-service`、`authcli`、`verify-sdk`、`demo-skill` 已完成当前阶段闭环
- `admin-console` 不进入当前关键路径，延后到最后完成

## Phase 3: Pilot And Productionization

- 试点 Skill 接入
- 监控告警
- 密钥管理与轮换
- 归档和运维手册

交付标准：

- 首批部门可稳定使用
- 关键安全告警可观测
- 生产部署与回滚可演练

执行顺序：

1. 主控仓与子仓状态收敛
2. 真实 E2E 验收报告归档
3. 首个试点 Skill 接入
4. 监控、演练脚本和运维文档落地
5. `admin-console` 最后启动
