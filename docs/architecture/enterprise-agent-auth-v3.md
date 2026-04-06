# 企业 Agent Skill 鉴权平台 V3.1 实施蓝图

> 版本：v3.1  
> 状态：`0.2.0` 规划冻结  
> 日期：2026-04-06

## 1. 摘要

`0.1.0-alpha` 已验证最小闭环可行，`0.2.0` 的目标不再是继续堆叠维度，而是把平台收敛到可运营、可维护、可快速扩展的最小模型。

平台固定定位如下：

- 飞书用户标识仍是唯一身份来源，当前只使用 `user_id/open_id`
- IAM 采用最小授权模型，不引入 `role`、`group`、`department`、`chat`、`agent` 作为授权维度
- 鉴权链路固定为 `Agent -> AuthCLI -> IAM Service -> Verify SDK -> Protected Service`
- 当前仓库是主控规划仓，不承载业务实现代码
- `0.2.0` 的交付是主控仓文档冻结与子仓任务书，不是本仓代码实现

## 2. 仓库拓扑与职责

### 2.1 主控仓

`aily-skills-auth` 负责：

- 维护架构蓝图
- 冻结接口契约
- 维护子项目注册表
- 提供模板、测试策略、部署规范
- 为各子仓输出 `0.2.0` 任务书

### 2.2 子仓清单

| 仓库 | 职责 | 输入 | 输出 |
|------|------|------|------|
| `aily-skills-auth-iam-service` | 决策、签发、撤销、审计、管理 API | 用户资料、技能配置、授权绑定、鉴权请求 | token、验证结果、管理 API |
| `aily-skills-auth-admin-console` | 管理与可视化 | IAM 管理 API | 用户维护、Skill 管理、Grant 管理、审计查询 |
| `aily-skills-auth-authcli` | 本地鉴权代理 | Skill 上下文、用户标识、本地配置 | token、CLI 输出、缓存 |
| `aily-skills-auth-verify-sdk` | 服务端验证 | token、标准身份头 | 鉴权上下文、拒绝结果 |
| `aily-skills-auth-demo-skill` | skill 模板与 service demo 样板 | AuthCLI、Verify SDK、冻结契约 | `skill-template`、`skill-sample`、`service-demo` 与回归样板 |

### 2.3 依赖方向

- `admin-console` 只依赖 `iam-service`
- `authcli` 只调用 `iam-service`
- `verify-sdk` 只调用 `iam-service` 的验证与撤销能力
- `demo-skill` 依赖 `authcli` 与 `verify-sdk` 的冻结契约

## 3. 统一领域模型

### 3.1 核心实体

- `User`: 飞书用户资料，主键为 `user_id/open_id`
- `Skill`: 企业注册技能
- `UserSkillGrant`: 用户与技能之间的授权绑定
- `AuditLog`: 鉴权、验证、管理操作的审计记录

### 3.2 授权主语义

平台采用最小授权模型：

- `Who`: `user_id`
- `What`: `skill_id`

授权是否成立，仅取决于：

- 是否存在匹配的 `UserSkillGrant`
- 记录 `status` 是否允许使用
- 当前时间是否位于 `effective_at` 与 `expires_at` 窗口内

### 3.3 UserSkillGrant 最小字段

- `grant_id`
- `user_id`
- `skill_id`
- `status`
- `effective_at`
- `expires_at`
- `updated_at`
- `updated_by`
- `reason`

`status` 在 `0.2.0` 至少包含：

- `active`
- `inactive`
- `revoked`

### 3.4 非目标

以下内容全部移出 `0.2.0` 主路径：

- `appid`
- `agent` 作为授权维度
- `chat_id` 作为授权或 verify 约束
- 飞书组织架构同步
- 通讯录同步
- `role`
- `group`
- `department` 参与授权决策
- `data_scope`
- `permissions`

## 4. Token 与验证语义

### 4.1 JWT Claims

`0.2.0` 采用最小 claims：

```json
{
  "iss": "auth.company.internal",
  "sub": "ou_xxx",
  "aud": "sales-analysis",
  "iat": 1775424000,
  "exp": 1775424300,
  "jti": "jt_xxx"
}
```

语义约束：

- `sub` 固定为 `user_id`
- `aud` 固定为 `skill_id`
- 不再包含 `auth_context.chat_id`、`agent_id`、`permissions`、`data_scope`

### 4.2 Verify 约束

- Verify SDK 不做策略重算
- `/api/v1/token/verify` 只验证 token 有效性、撤销状态，以及 `sub/aud` 与请求中 `user_id/skill_id` 是否一致
- 不再定义 `CHAT_CONTEXT_MISMATCH`
- `IDENTITY_MISMATCH` 仍需可审计、可告警

## 5. 冻结契约

以下契约在子仓进入 `0.2.0` 实施前必须冻结：

- `POST /api/v1/auth/check`
- `POST /api/v1/token/verify`
- `POST /api/v1/token/refresh`
- JWT payload 最小结构
- 错误码集合
- AuthCLI `json | env | exit-code | --help` 协议
- Token 缓存文件结构和命中/失效逻辑
- 标准 Skill 请求头集合
- 管理 API：`users`、`skills`、`grants`、`audit-logs`

契约定义见：

- [domain-model.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/domain-model.md)
- [auth-check.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/auth-check.md)
- [token-verify.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-verify.md)
- [token-refresh.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-refresh.md)
- [admin-management-api.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/admin-management-api.md)

## 6. `0.2.0` 子仓任务书

### 6.1 IAM Service

- 数据模型迁移到 `User`、`Skill`、`UserSkillGrant`、`AuditLog`
- 决策逻辑只按 `user_id + skill_id + status + 生效窗口`
- 管理 API 围绕用户、技能、授权、审计四组资源重构
- 部署要求固定为 `iam-service + PostgreSQL + Redis` 同一 Compose 拓扑
- `feishu-sync` 标注为 future / deferred

### 6.2 AuthCLI

- 命令面继续以 `auth-cli check --skill <skill_id>` 为主
- 帮助文案进入正式验收项
- 输入参数收敛到新模型；扩展参数只能作为兼容或审计辅助
- 安装与升级路径必须支持简单远程脚本分发

### 6.3 Verify SDK

- 服务端标准输入只要求 `Authorization`、`X-Auth-User-ID`、`X-Auth-Skill-ID`
- 远程 verify 返回最小鉴权上下文
- 删除与 `chat`、`agent` 绑定的验证规则

### 6.4 Demo Skill

- `service-demo` 负责示范服务端如何接入 `verify-sdk`
- `skill-template` 负责示范标准 Skill 如何先走 `authcli check` 再调用关键服务
- Skill 文档只冻结鉴权流程和标准头，不承载业务参数细节

### 6.5 Admin Console

- `0.2.0` 启动 MVP
- 页面固定为 `Users`、`Skills`、`Grants`、`Audit`
- 以可运营管理为目标，不引入复杂策略系统

## 7. 测试闭环

平台在 `0.2.0` 采用以下固定测试口径：

- 单元测试：授权绑定状态、生效窗口、JWT、缓存
- 契约测试：鉴权 API、验证 API、管理 API、AuthCLI 输出
- 集成测试：AuthCLI、Verify SDK、IAM Service 交互
- E2E 测试：`authcli -> service-demo -> verify-sdk -> iam-service`
- 安全测试：身份不一致、过期 token、撤销 token、上游不可用 fail-closed

详细矩阵见：

- [acceptance-matrix.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/acceptance-matrix.md)
- [e2e-scenarios.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/e2e-scenarios.md)
- [security-cases.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/security-cases.md)

## 8. 部署蓝图

`0.2.0` 固定部署分层如下：

- `iam-service + PostgreSQL + Redis` 为高聚合同一 Compose 单元
- `service-demo` 保持独立 Compose
- `authcli` 与 `verify-sdk` 采用易获取、易升级的分发方式，不作为 Compose 服务

详细见：

- [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md)

## 9. 默认决策

- 技术栈：服务端 Python/FastAPI，CLI Go，前端 React
- 架构组织：多仓库
- 当前仓库：资源主仓
- `0.1.0-alpha` 已完成 MVP 验证
- 当前推进顺序：先完成 `0.2.0` 规格收敛，再进入各子仓实施
- `admin-console` 不再延后到最后，而是作为 `0.2.0` 并行启动项
