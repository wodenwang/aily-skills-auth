# Phase 3 Pilot Execution

## 目标

在 `iam-service`、`authcli`、`verify-sdk`、`demo-skill` 已完成联调后，继续推进试点接入、监控告警、演练脚本和运维文档。这里的 `demo-skill` 指 `skill-template + skill-sample + service-demo` 组合样板。`admin-console` 已在 `0.2.0` 启动 MVP，可与试点并行推进，但不作为试点放行阻塞项。

## Agent Team

### Agent `lead`

职责：

- 收敛主控仓状态
- 维护试点推进节奏
- 审核跨仓接口漂移

写入范围：

- `README.md`
- `docs/architecture/**`
- `docs/roadmap/**`
- `registry/**`

交付：

- Phase 2 完成状态更新
- Phase 3 执行顺序和 owner 确认
- 首个试点 Skill 的接入范围确认

### Agent `quality`

职责：

- 归档真实 E2E 验收结果
- 补齐安全与回归场景
- 维护试点验收清单

写入范围：

- `docs/test-strategy/**`
- `examples/**`

交付：

- 一次跨四仓真实 E2E 验收报告
- 试点 Skill 验收矩阵
- revoke、identity mismatch、expired 的回归脚本说明

### Agent `runtime`

职责：

- 推动试点部署、监控和演练脚本
- 收敛运行时指标和告警规则
- 固化回滚与排障口径

写入范围：

- `docs/roadmap/**`
- `examples/**`

交付：

- 试点部署步骤
- 监控指标与告警规则
- 撤销、密钥轮换、缓存失效演练脚本说明
- 运维手册骨架

## 执行顺序

1. `lead` 先更新主控仓和注册表状态，明确 `admin-console` 已启动 MVP 且不阻塞试点放行。
2. `quality` 基于真实本地实现跑完整 E2E，归档结果。
3. `runtime` 输出试点部署、监控和演练文档。
4. 三者统一回到主控仓，冻结试点版交付标准。

## 当前优先事项

### P0

- 更新所有状态文档，消除“Phase 2 仍在进行中”的旧表述
- 补一份真实 E2E 验收报告，不再只保留 runbook
- 选定首个试点 Skill，并固定接入方式
- 冻结 `0.1.0-alpha` 的统一发布与部署方案

### P1

- 为 `identity_mismatch_count`、`token_revocation_count`、`token_verify_latency_p99` 定义指标采集口径
- 补撤销演练、缓存失效演练、密钥轮换演练步骤
- 形成试点版部署和回滚手册

### P2

- 在试点推进过程中持续收敛 `admin-console` MVP 与管理 API 的一致性

## 完成标准

- 主控仓和各子仓状态一致
- 真实 E2E 验收结果已归档
- 首个试点 Skill 可稳定接入
- 关键告警和演练步骤可执行
- `admin-console` 已进入并行推进状态，但不阻塞试点和生产化推进
