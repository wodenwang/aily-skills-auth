# First Pilot Skill Kickoff

## Goal

基于已经完成的 `0.1.0-alpha` MVP 验证和当前 `0.2.0` 规划冻结，正式启动首个真实试点 skill 的接入准备。

本文件的目标不是代替具体试点 skill 仓，而是把首个试点所需的固定输入、制品坐标、接入步骤和当前缺口收口到一处。

## Released Inputs

试点 skill 当前必须消费以下正式发布物或冻结规范：

- 主控仓规范：
  - [skill-template-spec.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-template-spec.md)
  - [pilot-skill-onboarding-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/pilot-skill-onboarding-checklist.md)
- `verify-sdk`：
  - [wodenwang/aily-skills-auth-verify-sdk v0.1.0-alpha](https://github.com/wodenwang/aily-skills-auth-verify-sdk/releases/tag/v0.1.0-alpha)
- `authcli`：
  - [wodenwang/aily-skills-auth-authcli v0.1.0-alpha](https://github.com/wodenwang/aily-skills-auth-authcli/releases/tag/v0.1.0-alpha)
- `iam-service`：
  - image: `ghcr.io/wodenwang/aily-skills-auth-iam-service:0.1.0-alpha`
- `service-demo`：
  - image: `ghcr.io/wodenwang/aily-skills-auth-demo-skill:0.1.0-alpha`

## Candidate Inventory

当前工作区里可见的真实 skill 类项目候选：

- [feishu-extension-skills](/Users/wenzhewang/workspace/codex/feishu-extension-skills/README.md)

当前判断：

- 它是一个真实 skill 项目，而不是纯样板
- 但它尚未被明确确认为“首个 Aily 试点 skill”
- 因此当前只能作为候选，不直接视为最终试点目标

## Required Decisions

在真正开始接入前，必须冻结以下信息：

- 目标试点仓
- `skill_id`
- 业务 owner
- Aily 运行宿主
- 下游业务服务地址
- `user_id` 来源

## Integration Path

### 1. 模板冻结

为目标 skill 生成一份基于 [skill-template-spec.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/skill-template-spec.md) 的实际接入文档。

### 2. AuthCLI 接入

目标 skill 宿主机安装已发布的 `authcli` 二进制，并固定：

- `AUTHCLI_IAM_BASE_URL`
- 缓存路径
- fail-closed 规则

### 3. 服务端接入

目标业务服务安装已发布的 `verify-sdk` 包，并接入：

- `Authorization`
- `X-Auth-User-ID`
- `X-Auth-Skill-ID`

### 4. 试点验证

至少验证：

- allow
- deny
- refresh
- identity mismatch reject
- revoke reject

## Current Status

当前状态：已启动，但仍缺少“目标试点 skill 仓”的最终确认。

已完成：

- `0.1.0-alpha` MVP 已验证
- 云端等价部署演练已经通过
- `0.2.0` 试点接入模板和清单已按最小模型收敛

当前阻塞：

- 尚未锁定首个真实 Aily 试点 skill 的具体仓和 owner

## Next Action

下一步只做一件事：

为首个真实试点 skill 确认目标仓和 `skill_id`，然后在该仓中落第一份正式接入文档。
