# Agents Team Kickoff

## Goal

把 `0.2.0` 的 agents team 从“角色定义”推进到“可直接执行”的启动状态。

本文件定义：

- agent 启动顺序
- 每个 agent 的输入、输出、边界
- agent 间 handoff 规则
- reviewer 审查插点
- 统一模型要求

## Unified Model Requirement

所有 sub-agent 必须使用与主 agent 相同的模型能力，不允许为了节省资源替换为 mini 模型或低能力变体。

执行规则：

- 不允许把 sub-agent 切换成 mini 模型
- 不允许在不同 sub-agent 之间混用不同能力层级，导致判断标准不一致
- 若某个 sub-agent 无法使用与主 agent 相同的模型，则该 agent 暂不启动

## Team Roster

1. `lead`
2. `contracts`
3. `reviewer`
4. `admin-spec`
5. `cli-template`
6. `reviewer`
7. `quality`
8. `release-ops`
9. `reviewer`
10. `lead`

## Wave 1

### `lead`

输入：

- [AGENTS.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/AGENTS.md)
- [README.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/README.md)
- [enterprise-agent-auth-v3.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/architecture/enterprise-agent-auth-v3.md)
- [implementation-phases.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/implementation-phases.md)
- [registry/subprojects.yaml](/Users/wenzhewang/workspace/codex/aily-skills-auth/registry/subprojects.yaml)

输出：

- 主文档一致性结论
- 图示、路线图、注册表的缺口清单

### `contracts`

输入：

- [AGENTS.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/AGENTS.md)
- `docs/contracts/**`
- [iam-core.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/iam-core.md)
- [policy-engine.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/policy-engine.md)
- [token-service.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/token-service.md)

输出：

- 公共契约一致性结论
- `user_id + skill_id` 最小模型下的冲突清单

### Gate 1 `reviewer`

输入：

- Wave 1 全部产物
- [reviewer-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/reviewer-checklist.md)

通过条件：

- 无 blocking findings
- 后续角色不需要依赖未冻结字段

## Wave 2

### `admin-spec`

输入：

- Wave 1 通过后的公共契约
- [admin-console.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/admin-console.md)
- [admin-management-api.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/admin-management-api.md)

输出：

- 管理面 MVP 一致性结论
- `users / skills / grants / audit-logs` 资源映射缺口

### `cli-template`

输入：

- Wave 1 通过后的公共契约
- [authcli.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/authcli.md)
- [authcli-output.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/authcli-output.md)
- [skill-template-spec.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-template-spec.md)
- [skill-script-reference-template.sh](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-script-reference-template.sh)
- [demo-skill-integration.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/examples/demo-skill-integration.md)

输出：

- CLI、模板、示例的一致性结论
- 命令面、header、样板职责的缺口清单

### Gate 2 `reviewer`

输入：

- Wave 2 全部产物
- [reviewer-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/reviewer-checklist.md)

通过条件：

- 管理面、CLI、模板三者口径一致
- 不存在未落文档的接口协商

## Wave 3

### `quality`

输入：

- 前两波通过后的契约和模板
- `docs/test-strategy/**`
- 试点相关 `docs/roadmap/*.md`

输出：

- 测试口径一致性结论
- 试点文档与当前模型的缺口清单

### `release-ops`

输入：

- 前两波通过后的契约和路线图
- [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md)
- [alpha-release-and-deployment-plan.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/alpha-release-and-deployment-plan.md)

输出：

- 部署与分发口径一致性结论
- Compose 边界、安装升级路径、历史 alpha 归档的缺口清单

### Gate 3 `reviewer`

输入：

- Wave 3 全部产物
- [reviewer-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/reviewer-checklist.md)

通过条件：

- 测试、试点、部署三者全部对齐 `0.2.0`
- 无未处理阻塞项

## Final Pass

### `lead`

输入：

- 全部 wave 产物
- 全部 reviewer findings

输出：

- 最终一致性结论
- `Changed files / Public interfaces / Verified / Open issues`

## Handoff Rules

- 任何 handoff 都必须引用具体文档，不允许说“按前面对齐”
- handoff 必须给出绝对路径
- 如果 handoff 依赖子仓实现细节，必须引用对应子仓 `AGENTS.md`
- 如果 handoff 依赖跨仓接口，必须引用主控仓冻结契约

## Failure Rules

- reviewer 出现 blocking findings 时，后续 wave 不启动
- 发现模型降级、mini 替代、低能力模型混用时，立即停止该 agent
- 发现子 agent 越权修改非自己范围文档时，交回 `lead` 裁决
