# AGENTS

本仓库是 `aily-skills-auth` 的主控规划仓，不直接承载业务实现代码。

目标是把企业 Agent Skill 鉴权平台在 `0.2.0` 阶段的实施边界、接口契约、模板和协作规则固定下来，供后续多个独立仓库继承。

## 1. 仓库角色

- 当前仓库只维护规划、规范、模板、契约、测试策略、子项目注册表
- 不在本仓库开发 `iam-service`、`authcli`、`verify-sdk`、`admin-console`
- 若需要实现代码，应在对应子仓中进行
- `0.2.0` 的目标是“规划冻结 + 子仓任务书”，不是在主控仓实现子仓功能

## 2. 文档优先级

执行时以以下文档顺序为准：

1. 当前仓 `AGENTS.md`
2. 子项目本仓 `AGENTS.md`
3. `docs/architecture/enterprise-agent-auth-v3.md`
4. `docs/contracts/*.md`
5. `docs/modules/*.md`
6. `docs/test-strategy/*.md`
7. `docs/roadmap/*.md`
8. `docs/templates/*.md`

若文档冲突：

- 平台边界与协作方式以当前仓 `AGENTS.md` 为准
- 子项目内部实现约束以对应子仓 `AGENTS.md` 为准
- 跨仓接口与公共语义以主控仓契约文档为准
- 设计与实施边界以 V3 主文档为准

## 3. 子项目边界

本项目从一开始采用多仓库模式。

固定子仓：

- `aily-skills-auth-iam-service`
- `aily-skills-auth-admin-console`
- `aily-skills-auth-authcli`
- `aily-skills-auth-verify-sdk`
- `aily-skills-auth-demo-skill`

约束：

- 每个子仓独立开发、调试、测试、发布
- 主控仓只维护它们的索引、模板和冻结契约
- 跨仓接口变更必须先更新主控仓文档，再进入实现仓
- 子仓内的实现细节、交付格式和局部边界，必须在各自子仓 `AGENTS.md` 中固定

## 4. 写入边界

允许修改：

- `README.md`
- `AGENTS.md`
- `docs/**`
- `registry/**`
- `examples/**`

禁止在本仓库新增：

- 生产服务源码
- 可执行 CLI 主体代码
- 前端应用代码
- SDK 运行时代码

## 5. `0.2.0` 冻结点

在子仓并行编码前，先冻结以下接口和模型：

- `POST /api/v1/auth/check`
- `POST /api/v1/token/verify`
- `POST /api/v1/token/refresh`
- JWT claims 最小结构
- `user_id + skill_id` 最小授权模型语义
- `User`、`Skill`、`UserSkillGrant`、`AuditLog` 最小资源模型
- Token 缓存文件格式与失效规则
- AuthCLI 输出协议与 `--help` 协议
- Skill 标准调用头集合
- Admin Management API：`users`、`skills`、`grants`、`audit-logs`
- 错误码集合
- 审计字段最小集合

`0.2.0` 明确移出主路径的能力：

- `appid`
- `agent` 作为授权维度
- `chat_id` 作为授权或 verify 约束
- 飞书组织架构同步
- 通讯录同步
- `role`
- `group`
- `department` 参与授权决策
- `permissions`
- `data_scope`
- 策略模拟器

## 6. Sub-Agent 协作规则

### 6.1 交互基线

- sub-agent 之间如果有交互，必须按照约定文档进行，不允许依赖口头说明、临时消息或未落文档的默认理解
- 优先使用各子项目自己的 `AGENTS.md` 作为该子仓的唯一执行入口
- 若交互涉及跨仓公共接口，必须回到主控仓冻结契约
- 所有 sub-agent 必须与主 agent 使用同一模型能力，不允许切换到 mini、lite 或其他降配模型

### 6.2 强制规则

- `iam-service` agent 输出给 `authcli`、`verify-sdk`、`admin-console` 的所有公共接口语义，必须先落到主控仓契约文档，再进入实现仓
- `authcli` agent 与 `demo-skill` agent 的交互，必须以 `authcli` 子仓 `AGENTS.md` 中约定的命令面、帮助文案、输出协议为准
- `verify-sdk` agent 与 `service-demo` 或真实业务服务 agent 的交互，必须以 `verify-sdk` 子仓 `AGENTS.md` 中约定的 header、错误码、verify 行为为准
- `admin-console` agent 只能依赖 `iam-service` 子仓 `AGENTS.md` 和主控仓 `admin-management-api.md` 中已冻结的资源模型
- `quality` agent 编写验收与联调用例时，只能引用已冻结文档，不得发明测试专用语义
- `reviewer` agent 不直接定义接口，不直接修改执行结论，只根据冻结文档检查偏差、缺口和顺序违规
- 任何 sub-agent 若使用了与主 agent 不同的模型配置，视为流程违规，必须重新执行该阶段

### 6.3 冲突处理

- 若主控仓契约与子仓 `AGENTS.md` 冲突，必须先修文档，再继续推进
- 不允许带着冲突口径并行编码
- 不允许某个 sub-agent 通过实现反向定义契约

### 6.4 审核者工作方式

- `reviewer` 必须在每个阶段结束后做一次审查，而不是只在最后集中审查
- `reviewer` 的审查输入只允许来自当前仓 `AGENTS.md`、子仓 `AGENTS.md`、主控仓冻结契约和相关阶段产物
- `reviewer` 发现问题后，必须按“问题描述 -> 影响范围 -> 依据文档 -> 建议动作”输出
- `reviewer` 可以阻塞进入下一阶段，但不能绕过 `lead` 直接改写公共决策
- `reviewer` 的具体检查项以 [reviewer-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/reviewer-checklist.md) 为准

## 7. `0.2.0` 推荐协作分工

### Agent 1: `lead`

职责：

- 维护 V3 主文档
- 维护 README、架构图、时序图
- 维护子项目注册表与总体路线图
- 维护主控仓协作规则
- 裁决跨文档冲突

写入范围：

- `README.md`
- `AGENTS.md`
- `docs/architecture/**`
- `docs/roadmap/**`
- `registry/**`

### Agent 2: `contracts`

职责：

- 维护接口契约
- 维护领域模型
- 维护错误码和缓存协议
- 冻结 JWT claims 和最小资源模型

写入范围：

- `docs/contracts/**`
- `docs/modules/iam-core.md`
- `docs/modules/policy-engine.md`
- `docs/modules/token-service.md`

### Agent 3: `cli-template`

职责：

- 收敛 `authcli` 命令面
- 收敛 `--help` 规范
- 维护 Skill 模板和脚本参考
- 维护 demo-skill 接入样板

写入范围：

- `docs/modules/authcli.md`
- `docs/templates/**`
- `examples/**`

### Agent 4: `admin-spec`

职责：

- 定义 `admin-console` MVP 信息架构
- 定义页面流程与资源模型映射
- 维护 `users`、`skills`、`grants`、`audit-logs` 管理面规格

写入范围：

- `docs/modules/admin-console.md`
- `docs/contracts/admin-management-api.md`

### Agent 5: `quality`

职责：

- 维护测试策略和验收矩阵
- 维护 E2E 与安全口径
- 维护试点接入与运行文档

写入范围：

- `docs/test-strategy/**`
- `docs/roadmap/pilot-*.md`
- `docs/roadmap/first-pilot-skill-kickoff.md`

### Agent 6: `release-ops`

职责：

- 维护部署蓝图
- 维护历史 alpha 基线说明
- 维护子仓实施顺序与分发方式说明

写入范围：

- `docs/roadmap/deployment-blueprint.md`
- `docs/roadmap/implementation-phases.md`
- `docs/roadmap/alpha-release-and-deployment-plan.md`

### Agent 7: `reviewer`

职责：

- 审核整个 agents team 的执行情况
- 检查是否按阶段顺序推进
- 检查是否存在未落文档的接口协商
- 检查主控仓与子仓 `AGENTS.md`、契约文档之间的冲突
- 尽早发现范围漂移、字段漂移、阶段越界和测试口径失真

写入范围：

- 默认不直接写业务规格文档
- 允许在 `AGENTS.md` 中维护审核规则
- 允许在 review 输出中引用任意冻结文档和阶段产物

输出要求：

- 只输出审查发现、风险、阻塞项和建议动作
- 不替代执行 agent 编写正式规格
- 不通过临时判断创造新契约

## 8. `0.2.0` 推进顺序

按以下顺序推进，不建议跳步：

1. `lead`
2. `contracts`
3. `reviewer` 对 `lead + contracts` 做阶段审查
4. `admin-spec`
5. `cli-template`
6. `reviewer` 对管理面与模板面做阶段审查
7. `quality`
8. `release-ops`
9. `reviewer` 做发布前一致性审查
10. `lead` 最终一致性检查

顺序说明：

- `lead` 先锁定主文档、README、图示和注册表状态
- `contracts` 在主文档基线上冻结最小模型和三条核心接口
- `reviewer` 先检查冻结边界是否闭合，再允许后续角色继续推进
- `admin-spec` 在契约冻结后定义管理面，避免前端反向推接口
- `cli-template` 在公共契约稳定后统一重写 CLI 与模板样板
- `reviewer` 再检查模板、管理面与契约是否一致
- `quality` 在前述产物收敛后重写验收与试点文档
- `release-ops` 最后整理部署与分发说明
- `reviewer` 在最终交付前检查阶段越界、术语漂移和残留旧模型

正式启动与 handoff 规则见 [agents-team-kickoff.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/agents-team-kickoff.md)。

## 9. 交付格式

```text
Changed files:
- path/a.md
- path/b.yaml

Public interfaces:
- /api/v1/auth/check
- auth-cli check --skill <skill_id>

Verified:
- docs reviewed
- registry updated

Open issues:
- ...
```

`reviewer` 的输出建议固定为：

```text
Review findings:
- issue / risk / conflict

Evidence:
- path/to/doc.md

Required action:
- update contract / stop next phase / align subproject AGENTS
```

## 10. Definition of Done

满足以下条件可视为当前阶段完成：

- V3 主文档可直接指导子仓实施
- 子项目注册表完整且状态同步
- 契约文档冻结
- 测试矩阵完整
- Demo Skill 模板职责清晰
- Admin Console MVP 规格清晰
- 部署蓝图明确 `iam-service + db + redis` 与 `demo-service` 的拆分
- sub-agent 协作规则已写入文档并可执行
- `reviewer` 已完成阶段性审查，且无未处理阻塞项

## 11. 不建议的做法

- 在接口未冻结前启动多个子仓编码
- 把实现细节散落在主控仓任意位置
- 在主控仓写临时生产代码再迁移
- 让多个角色同时改同一份契约文档而不先冻结边界
- 让 sub-agent 通过临时消息协商接口，而不先更新文档
- 让实现仓用代码事实反向定义主控仓契约
