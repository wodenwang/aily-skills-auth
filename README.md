# Aily Skills Auth

`aily-skills-auth` 是企业 Agent Skill 鉴权平台的主控规划仓。

这个仓库不承载生产实现代码，职责是沉淀以下资产：

- V3 整体设计文档与架构决策
- 子项目拆分方案与注册表
- 接口契约与领域模型
- 测试策略、验收矩阵、部署蓝图
- 子项目可复用模板与协作规范

## 仓库定位

- 类型：模板与规范资源仓
- 目标：为后续多仓库实施提供唯一规划入口
- 非目标：不在本仓库实现 `iam-service`、`authcli`、`verify-sdk`、`admin-console`

## 子项目索引

| 仓库 | 角色 | 技术栈 | 状态 |
|------|------|--------|------|
| `aily-skills-auth` | 主控规划/资源仓 | Markdown/YAML | 当前仓库 |
| `aily-skills-auth-iam-service` | 鉴权决策与签发服务 | Python + FastAPI | 规划中 |
| `aily-skills-auth-admin-console` | 管理控制台 | React | 规划中 |
| `aily-skills-auth-authcli` | 本地鉴权 CLI | Go | 规划中 |
| `aily-skills-auth-verify-sdk` | 服务端验证 SDK | Python first | 规划中 |
| `aily-skills-auth-demo-skill` | 端到端示例 Skill | Bash/Python | 规划中 |

## 文档入口

- 总览：[docs/README.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/README.md)
- V3 蓝图：[docs/architecture/enterprise-agent-auth-v3.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/architecture/enterprise-agent-auth-v3.md)
- 子项目拆分：[docs/roadmap/repo-splitting-plan.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/repo-splitting-plan.md)
- 部署蓝图：[docs/roadmap/deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md)
- 注册表：[registry/subprojects.yaml](/Users/wenzhewang/workspace/codex/aily-skills-auth/registry/subprojects.yaml)

## GitHub 同步原则

- 本地目录与 GitHub 仓库 `aily-skills-auth` 一一对应
- 该仓库只同步文档、模板、规范和示例
- 后续实现仓独立创建，不在这里承载过渡代码

## 当前完成标准

当前阶段完成，需满足：

- V3 主文档定稿并可指导子仓实施
- 子项目边界与注册表稳定
- 契约文档与测试矩阵冻结
- 部署规划覆盖 POC、试点、生产三层
