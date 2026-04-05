# 企业 Agent Skill 鉴权平台 V3.0 实施蓝图

> 版本：v3.0  
> 状态：实施蓝图  
> 日期：2026-04-05

## 1. 摘要

V3 的目标不是再次证明方案可行，而是把方案转换成可直接拆分、开发、测试、部署的工程蓝图。

平台固定定位如下：

- 飞书是唯一主身份源
- IAM 采用自建轻量模型，不引入 SSO、LDAP、MFA、多租户
- 鉴权链路固定为 `Agent -> AuthCLI -> IAM Service -> Verify SDK -> Data API`
- 当前仓库是主控规划仓，不承载业务实现代码
- 所有生产实现通过独立子仓完成

## 2. 仓库拓扑与职责

### 2.1 主控仓

`aily-skills-auth` 负责：

- 维护架构蓝图
- 冻结接口契约
- 维护子项目注册表
- 提供模板、测试策略、部署规范

### 2.2 子仓清单

| 仓库 | 职责 | 输入 | 输出 |
|------|------|------|------|
| `aily-skills-auth-iam-service` | 决策、签发、撤销、审计、同步 | 飞书身份、管理配置、鉴权请求 | token、验证结果、管理 API |
| `aily-skills-auth-admin-console` | 管理与可视化 | IAM 管理 API | 策略配置、审计浏览、模拟测试 |
| `aily-skills-auth-authcli` | 本地鉴权代理 | Agent 上下文、用户/群上下文 | token、CLI 输出、缓存 |
| `aily-skills-auth-verify-sdk` | 服务端验证 | token、身份头、撤销状态 | 鉴权上下文、拒绝结果 |
| `aily-skills-auth-demo-skill` | skill 模板与 service demo 样板 | AuthCLI、后端 API | `skill-template`、`skill-sample`、`service-demo` 与回归场景 |

### 2.3 依赖方向

- `admin-console` 只依赖 `iam-service`
- `authcli` 只调用 `iam-service`
- `verify-sdk` 只调用 `iam-service` 的验证/密钥/撤销能力
- `demo-skill` 依赖 `authcli` 与 `verify-sdk` 的冻结契约，并用于承载 `skill-template`、`skill-sample`、`service-demo`

## 3. 统一领域模型

### 3.1 核心实体

- `User`: 飞书用户，主键为 `open_id`
- `Department`: 飞书同步后的组织节点
- `Role`: 业务角色，与飞书职位解耦
- `Agent`: 员工专属虚拟机或宿主实例
- `Skill`: 企业注册技能
- `Chat`: 飞书私聊或群聊上下文
- `Policy`: 面向 Skill 的访问策略
- `Token`: 短期 JWT，带审计与撤销标识
- `AuditLog`: 每次鉴权和验证链路的审计记录

### 3.2 权限模型

平台采用五维模型：

- `Who`: user
- `Via`: agent
- `Where`: chat
- `What`: skill
- `How Much`: data_scope

群策略采用三态模型：

- `disabled`
- `allowed_all`
- `allowed_list`

语义定义：

- `disabled`: 只允许私聊，默认不开放群聊
- `allowed_all`: 允许私聊和所有群聊
- `allowed_list`: 允许私聊，群聊仅允许白名单中的 chat

### 3.3 设计约束

- IAM Service 是唯一策略评估与 token 签发源
- Verify SDK 不做策略重算
- AuthCLI 不做策略解释
- 群策略只决定“群中能否用”，角色策略决定“能看什么”
- token verify 必须校验 `user_id + skill_id + agent_id + chat_id` 与 token `auth_context` 一致
- token 不允许跨 chat 复用

## 4. 冻结契约

以下契约在子仓启动前必须冻结：

- 鉴权请求字段：`user_id`, `skill_id`, `agent_id`, `chat_id`, `context`
- `POST /api/v1/auth/check`
- `POST /api/v1/token/verify`
- `POST /api/v1/token/refresh`
- JWT payload 结构
- 错误码集合
- AuthCLI `json | env | exit-code` 输出协议
- Token 缓存文件结构和命中/失效逻辑
- 审计字段最小集合

契约定义见：

- [domain-model.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/domain-model.md)
- [auth-check.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/auth-check.md)
- [token-verify.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-verify.md)
- [token-refresh.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-refresh.md)

## 5. 实施拆分

### 5.1 Phase 0: 规划冻结

- 冻结 V3 文档
- 冻结注册表、模块边界、测试矩阵
- 确认 GitHub 主控仓与子仓命名规则

### 5.2 Phase 1: IAM Service + AuthCLI MVP

- `iam-service` 实现用户/角色/部门、策略引擎、JWT、审计、飞书同步
- `authcli` 实现身份采集、缓存、鉴权请求、重试
- `demo-skill` 提供最小 `skill-template + skill-sample + service-demo` 样板

### 5.3 Phase 2: Verify SDK + Demo Skill

- 启动 `verify-sdk`，实现远程 token 验证、上下文一致性校验和标准错误映射
- 用 `demo-skill` 中的 `skill-sample + service-demo` 闭合 `authcli -> verify-sdk -> iam-service` 的完整验证链路
- 覆盖跨 chat 复用拒绝与 revoke 后拒绝

### 5.4 Phase 3: 试点与生产化

- 引入首批试点 Skill
- 建立监控告警、运维流程、密钥轮换
- 做性能、安全和权限变更回归
- `admin-console` 延后到最后，不作为当前阶段阻塞项

### 5.5 Phase 4: Admin Console

- 最后实现 `admin-console`
- 管理 API 和策略模拟器契约保持以前置冻结文档为准

## 6. 测试闭环

平台固定采用五层测试：

- 单元测试：策略规则、JWT、缓存、字段解析
- 契约测试：API 请求响应与错误码
- 集成测试：AuthCLI、Verify SDK、IAM Service 交互
- E2E 测试：完整链路
- 安全测试：伪造身份、过期/撤销 token、群策略绕过、跨 chat 复用 token

详细矩阵见：

- [acceptance-matrix.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/acceptance-matrix.md)
- [e2e-scenarios.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/e2e-scenarios.md)
- [security-cases.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/security-cases.md)

## 7. 部署蓝图

平台分三层部署：

- POC：单节点 + Docker Compose
- 试点：小规模 K8s + PostgreSQL 主备 + Redis
- 生产：多可用区 K8s、密钥轮换、对象存储归档、完整告警

详细见：

- [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md)

## 8. 实施风险

### 8.1 工程风险

- 子仓边界不清导致重复实现
- 契约变更未同步导致联调失败
- 主控仓被误用为实现仓

### 8.2 安全风险

- Skill 试图绕过 AuthCLI
- 服务端未校验身份一致性
- Token 撤销传播滞后

### 8.3 组织风险

- 策略配置复杂度过高
- 角色模型与飞书组织信息耦合过深
- 试点 Skill 选择过于敏感，影响推动节奏

## 9. 默认决策

- 技术栈：服务端 Python/FastAPI，CLI Go，前端 React
- 架构组织：多仓库
- 当前仓库：资源主仓
- 同名 GitHub 仓库：先承载模板与规范，不承载实现代码
- Phase 2 顺序：`verify-sdk` 和 `demo-skill` 先于 `admin-console` 前端实现
- 当前推进顺序：Phase 3 的试点与生产化工作优先于 `admin-console`
