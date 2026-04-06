# Reviewer Checklist

## Purpose

本清单用于指导 `reviewer` sub-agent 在 `0.2.0` 推进过程中做阶段性审查。

目标不是替代执行 agent，而是尽早发现：

- 阶段顺序违规
- 未落文档的接口协商
- 主控仓与子仓 `AGENTS.md` 冲突
- 公共字段漂移
- 范围漂移
- 验收口径失真

## Inputs

`reviewer` 只允许使用以下输入：

- 当前仓 [AGENTS.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/AGENTS.md)
- 对应子仓 `AGENTS.md`
- 主控仓 `docs/contracts/**`
- 主控仓 `docs/modules/**`
- 主控仓 `docs/roadmap/**`
- 当前阶段交付产物

禁止使用以下方式得出结论：

- 口头补充说明
- 临时聊天中未落文档的约定
- 执行 agent 的主观解释
- 以实现代码反推主控契约

## Review Gates

### Gate 1: `lead + contracts` 后

目标：

- 确认冻结边界闭合
- 确认后续 agent 有可执行的公共基线

检查项：

- [ ] [AGENTS.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/AGENTS.md) 已固定 `0.2.0` team、顺序和协作规则
- [ ] 所有 sub-agent 与主 agent 使用同一模型，没有降级到 mini 或其他低配模型
- [ ] [enterprise-agent-auth-v3.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/architecture/enterprise-agent-auth-v3.md) 与 [README.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/README.md) 的目标状态一致
- [ ] [domain-model.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/domain-model.md) 已固定 `user_id + skill_id` 模型
- [ ] [auth-check.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/auth-check.md)、[token-verify.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-verify.md)、[token-refresh.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-refresh.md) 相互一致
- [ ] JWT claims、错误码、缓存键与输出协议没有继续依赖 `appid`、`agent_id`、`chat_id`
- [ ] `0.2.0` 非目标已明确标注为移出主路径或 deferred
- [ ] 注册表状态与路线图阶段状态一致

阻塞条件：

- 发现任一 sub-agent 使用了与主 agent 不一致的降配模型
- 发现任何公共契约仍要求 `agent_id` 或 `chat_id` 才能运行
- 发现 README、主文档、契约三者对 `0.2.0` 目标表述不一致
- 发现子仓将依赖未冻结字段继续推进

### Gate 2: `admin-spec + cli-template` 后

目标：

- 确认管理面、CLI 与模板面对同一套公共契约

检查项：

- [ ] [admin-management-api.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/admin-management-api.md) 与 [admin-console.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/admin-console.md) 的资源模型一致
- [ ] `users / skills / grants / audit-logs` 四组资源没有夹带 `role/group/chat/department` 旧模型
- [ ] [authcli.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/modules/authcli.md) 与 [authcli-output.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/authcli-output.md) 的命令面一致
- [ ] `auth-cli check --help` 已被当成正式验收面，而不是补充说明
- [ ] [skill-template-spec.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-template-spec.md)、[skill-script-reference-template.sh](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-script-reference-template.sh)、[demo-skill-integration.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/examples/demo-skill-integration.md) 对标准头集合的要求一致
- [ ] Skill Markdown 主模板没有重新塞回业务参数说明
- [ ] `service-demo` 样板只承担服务端鉴权接入职责

阻塞条件：

- 管理 API 与管理台页面流程依赖不同字段
- `authcli` 模块文档、输出契约、模板示例三者命令面不一致
- Skill 模板和 demo 样板对关键 header 写法不一致

### Gate 3: `quality + release-ops` 后

目标：

- 确认测试口径、试点口径和部署口径与 `0.2.0` 一致

检查项：

- [ ] [acceptance-matrix.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/acceptance-matrix.md)、[e2e-scenarios.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/e2e-scenarios.md)、[security-cases.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/security-cases.md) 已切换到最小模型
- [ ] 试点文档没有继续把 `cross-chat`、`chat_context_mismatch` 作为当前目标
- [ ] [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md) 已明确 `iam-service + PostgreSQL + Redis` 同一 Compose 单元
- [ ] [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md) 已明确 `service-demo` 独立 Compose
- [ ] 部署文档已明确 `authcli` 与 `verify-sdk` 走分发安装，不走 Compose
- [ ] 历史 alpha 文档被保留为基线，而不是继续承载 `0.2.0` 决策

阻塞条件：

- 测试口径仍要求旧模型才能通过
- 试点文档与当前公共契约冲突
- 部署蓝图对 Compose 切分表述不清

### Gate 4: Final Review

目标：

- 在 `lead` 最终收口前，确认没有未处理阻塞项

检查项：

- [ ] 所有活跃文档入口已更新到最新路径
- [ ] 旧模型残留只存在于历史归档文档，不存在于当前规范主路径
- [ ] `policy-simulator`、`feishu-sync` 等 deferred 能力已明确标注状态
- [ ] 子仓如果已有 `AGENTS.md`，其公共接口表述没有与主控仓冲突
- [ ] 当前阶段没有 agent 越权修改不属于自己写入范围的文档
- [ ] 所有阻塞项都已有明确 owner 和处理动作
- [ ] 所有参与执行的 sub-agent 都遵守同模型要求

阻塞条件：

- 主路径文档仍残留未声明的旧模型字段
- 存在 unresolved 的跨仓契约冲突
- 存在未记录 owner 的阻塞项

## Findings Format

`reviewer` 输出必须使用以下结构：

```text
Review findings:
- issue / risk / conflict

Evidence:
- /absolute/path/to/doc.md

Required action:
- update contract / stop next phase / align subproject AGENTS
```

规则：

- 先写发现，再写证据，再写动作
- 每条问题必须能落到具体文档
- 如果没有问题，必须明确写 `no blocking findings`

## Escalation Rules

- 发现公共契约冲突时，升级给 `lead + contracts`
- 发现管理面与契约冲突时，升级给 `lead + admin-spec`
- 发现 CLI、模板、示例不一致时，升级给 `lead + cli-template`
- 发现测试口径漂移时，升级给 `lead + quality`
- 发现部署与分发表述冲突时，升级给 `lead + release-ops`

## Exit Rule

当且仅当以下条件同时满足时，`reviewer` 才能给出通过结论：

- 所有 Gate 已执行
- 没有未处理 blocking findings
- 所有发现都已有 owner 和明确动作
