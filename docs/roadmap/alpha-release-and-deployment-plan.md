# `0.1.0-alpha` Release And Deployment Plan

## Goal

冻结 `0.1.0-alpha` 的统一打包、发布与部署方案，作为试点上云前的唯一总览入口。

## Default Decisions

- 默认云环境：阿里云容器化
- 默认发布入口：`Git tag + GitHub Release`
- 统一版本：`0.1.0-alpha`
- 统一 Git tag：`v0.1.0-alpha`
- Python 包元数据按 PEP 440 使用 `0.1.0a0`
- `admin-console` 不纳入当前 alpha 关键路径

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

### 最终 Skill

- [final skill release profile](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/final-skill-release-profile.md)
- [skill-template release profile](/Users/wenzhewang/workspace/codex/aily-skills-auth-demo-skill/docs/skill-template/release-profile.md)
- [skill-sample release profile](/Users/wenzhewang/workspace/codex/aily-skills-auth-demo-skill/docs/skill-sample/release-profile.md)

发布物：

- 声明式 Markdown 文档包
- 最小 shell 脚本参考实现

## Release Order

1. `aily-skills-auth`
2. `aily-skills-auth-verify-sdk`
3. `aily-skills-auth-iam-service`
4. `aily-skills-auth-authcli`
5. `aily-skills-auth-demo-skill`
6. 首个真实试点 skill

排序原则：

- `verify-sdk` 先发布，供下游服务镜像消费其 wheel 制品
- `iam-service` 在 `authcli` 与 `service-demo` 前稳定其运行时接口
- `demo-skill` 最后发布，因为它依赖已构建的 `verify-sdk` 制品

## Verification

- 五个模块都存在对应的 release / deployment 文档
- 主控仓文档能链接到每个模块的明细说明
- 外部发布名统一使用 `0.1.0-alpha` 和 `v0.1.0-alpha`
- Python 包元数据统一使用 `0.1.0a0`
- `service-demo` 保持真实 E2E 校验能力
- 发布前总检查以 [alpha-release-readiness-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/alpha-release-readiness-checklist.md) 为准
- 打包验证记录见 [alpha-packaging-verification-2026-04-06.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/alpha-packaging-verification-2026-04-06.md)

## Notes

- 本轮冻结文档，不直接执行 tag、release 或部署
- 当前仓内包元数据可在真正 cut alpha 版本时再统一改写
