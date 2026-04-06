# `0.1.0-alpha` Release And Deployment Plan

## Goal

归档 `0.1.0-alpha` 的统一打包、发布与部署方案，作为 MVP 已验证成功后的历史基线。

## Status

- `0.1.0-alpha` 已完成 MVP 验证
- 当前阶段不再扩展 alpha 范围
- 后续规划以 `0.2.0` 文档收敛为主

## Default Decisions

- 默认云环境：阿里云容器化
- 默认发布入口：`Git tag + GitHub Release`
- 统一版本：`0.1.0-alpha`
- 统一 Git tag：`v0.1.0-alpha`
- Python 包元数据按 PEP 440 使用 `0.1.0a0`
- `admin-console` 不纳入 alpha 关键路径

## Module Index

### 基础平台

- [aily-skills-auth-iam-service release and deployment](/Users/wenzhewang/workspace/codex/aily-skills-auth-iam-service/docs/release-and-deployment.md)

发布物：

- `v0.1.0-alpha`
- GitHub Release
- 容器镜像 `ghcr.io/<org>/aily-skills-auth-iam-service:0.1.0-alpha`

### CLI 客户端

- [aily-skills-auth-authcli release and distribution](/Users/wenzhewang/workspace/codex/aily-skills-auth-authcli/docs/release-and-distribution.md)

发布物：

- `v0.1.0-alpha`
- GitHub Release
- Darwin / Linux 二进制压缩包

### SDK

- [aily-skills-auth-verify-sdk release and deployment](/Users/wenzhewang/workspace/codex/aily-skills-auth-verify-sdk/docs/release-and-deployment.md)

发布物：

- `v0.1.0-alpha`
- GitHub Release
- Python wheel / sdist
- Python 包版本 `0.1.0a0`

### Demo 服务

- [service-demo release and deployment](/Users/wenzhewang/workspace/codex/aily-skills-auth-demo-skill/docs/service-demo/release-and-deployment.md)

发布物：

- `v0.1.0-alpha`
- GitHub Release
- 容器镜像 `ghcr.io/<org>/aily-skills-auth-demo-skill:0.1.0-alpha`

## Verification

- 五个模块都存在对应的 release / deployment 文档
- 主控仓文档能链接到每个模块的明细说明
- 外部发布名统一使用 `0.1.0-alpha` 和 `v0.1.0-alpha`
- Python 包元数据统一使用 `0.1.0a0`
- `service-demo` 保持真实 E2E 校验能力
- 打包验证记录见 [alpha-packaging-verification-2026-04-06.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/alpha-packaging-verification-2026-04-06.md)

## Notes

- 本文档作为 alpha 基线保留，不再承载后续版本规划
- `0.2.0` 的部署与实施方向以 [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md) 和 [implementation-phases.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/implementation-phases.md) 为准
