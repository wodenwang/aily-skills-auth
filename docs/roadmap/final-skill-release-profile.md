# Final Skill Release Profile

## Goal

定义“最终 Skill”在 `0.1.0-alpha` 阶段的发布与部署标准。

当前没有独立真实 skill 仓，所以本规范先由主控仓与 `demo-skill` 共同承载，等首个试点 skill 仓创建后直接继承。

## Release Target

- 版本：`0.1.0-alpha`
- Git tag：`v0.1.0-alpha`
- 发布入口：GitHub Release

## Deliverables

### Primary Artifact

- 声明式 Skill 文档包

最低包含：

- skill metadata
- runtime context
- `authcli` 调用规则
- 下游服务标准头
- 失败处理
- 验收清单

### Secondary Artifact

- 最小 shell 脚本参考实现

规则：

- 脚本是 reference implementation，不是模板本体
- Skill 发布包必须包含 Markdown 模板

## Deployment Profile

- Skill 本体部署在飞书 Aily 所需云端环境
- Skill 运行时通过宿主机 `authcli` 访问 IAM
- Skill 下游通过 HTTP 调业务服务或 `service-demo`

## Required Inheritance

首个真实试点 skill 仓至少应继承：

- [skill-template-spec.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-template-spec.md)
- [pilot-skill-onboarding-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/pilot-skill-onboarding-checklist.md)
- `authcli` 运行与 fail-closed 规则

## Exclusions

- 当前不规划独立包仓
- 当前不规划脚本安装器
- 当前不规划多语言 skill 适配
