# AGENTS

本仓库是 `aily-skills-auth` 的主控规划仓，不直接承载业务实现代码。

目标是把企业 Agent Skill 鉴权平台的实施边界、接口契约、模板和协作规则固定下来，供后续多个独立仓库继承。

## 1. 仓库角色

- 当前仓库只维护规划、规范、模板、契约、测试策略、子项目注册表
- 不在本仓库开发 `iam-service`、`authcli`、`verify-sdk`、`admin-console`
- 若需要实现代码，应在对应子仓中进行

## 2. 文档优先级

执行时以以下文档顺序为准：

1. `AGENTS.md`
2. `docs/architecture/enterprise-agent-auth-v3.md`
3. `docs/modules/*.md`
4. `docs/contracts/*.md`
5. `docs/test-strategy/*.md`
6. `docs/roadmap/*.md`
7. `docs/templates/*.md`

若文档冲突：

- 平台边界与协作方式以 `AGENTS.md` 为准
- 设计与实施边界以 V3 主文档为准
- 具体模块说明以模块文档和契约文档为准

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

## 5. 接口冻结点

在子仓并行编码前，先冻结以下接口：

- `POST /api/v1/auth/check`
- `POST /api/v1/token/verify`
- `POST /api/v1/token/refresh`
- JWT claims 结构
- 四元组与五维模型语义
- Token 缓存文件格式与失效规则
- AuthCLI 输出协议
- 错误码集合
- 审计字段最小集合

## 6. 推荐协作分工

### Agent 1: `lead`

职责：

- 维护 V3 主文档
- 维护子项目注册表与总体路线图
- 冻结跨仓接口

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

写入范围：

- `docs/contracts/**`
- `docs/modules/policy-engine.md`
- `docs/modules/token-service.md`
- `docs/modules/authcli.md`
- `docs/modules/verify-sdk.md`

### Agent 3: `quality`

职责：

- 维护测试策略和验收矩阵
- 维护示例集成文档

写入范围：

- `docs/test-strategy/**`
- `examples/**`

## 7. 交付格式

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

## 8. Definition of Done

满足以下条件可视为当前阶段完成：

- V3 主文档可直接指导子仓实施
- 子项目注册表完整
- 契约文档冻结
- 测试矩阵完整
- 部署蓝图包含 POC、试点、生产

## 9. 不建议的做法

- 在接口未冻结前启动多个子仓编码
- 把实现细节散落在主控仓任意位置
- 在主控仓写临时生产代码再迁移
- 让多个角色同时改同一份契约文档而不先冻结边界
