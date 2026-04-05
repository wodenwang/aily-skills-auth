# `0.1.0-alpha` Release Readiness Checklist

## Goal

把 `0.1.0-alpha` 从“文档冻结完成”推进到“可实际 cut alpha 版本”的发布前检查顺序固定下来。

本清单仍然不直接执行发布，只定义在真正创建 `v0.1.0-alpha` 前必须逐项确认的内容。

## Scope

覆盖五个模块：

- `aily-skills-auth`
- `aily-skills-auth-iam-service`
- `aily-skills-auth-authcli`
- `aily-skills-auth-verify-sdk`
- `aily-skills-auth-demo-skill`

## Checklist

### 1. 文档冻结

- 主控仓已存在 [alpha-release-and-deployment-plan.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/alpha-release-and-deployment-plan.md)
- 主控仓已存在 [final-skill-release-profile.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/final-skill-release-profile.md)
- 五个模块都存在各自的 release / deployment 文档
- 外部发布名统一使用 `0.1.0-alpha` 与 `v0.1.0-alpha`
- Python 包元数据统一使用 `0.1.0a0`
- `admin-console` 未被错误纳入 alpha 关键路径

### 2. 制品定义确认

- `iam-service` 主发布物定义为容器镜像
- `authcli` 主发布物定义为 Darwin / Linux 二进制压缩包
- `verify-sdk` 主发布物定义为 wheel / sdist
- `service-demo` 主发布物定义为容器镜像
- 最终 skill 主发布物定义为 Markdown 文档包，脚本仅作参考实现

### 3. 打包命令可执行

- `iam-service` 镜像构建命令可执行
- `authcli` `go build` 可执行
- `verify-sdk` wheel / sdist 构建命令可执行
- `service-demo` 镜像构建命令可执行
- 当前验证记录见 [alpha-packaging-verification-2026-04-06.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/alpha-packaging-verification-2026-04-06.md)

### 4. 最小运行验证

- `iam-service` 可在 PostgreSQL + Redis 依赖下启动
- `authcli` 可执行 `auth-cli check --skill <skill_id>`
- `verify-sdk` FastAPI 集成样例可运行
- `service-demo` 可通过 `GET /healthz`
- `service-demo` 契约保持：
  - `POST /api/demo/query`
  - body 仅含 `query`
  - 认证信息走标准头

### 5. 集成验证

- `demo-skill` 真实 E2E 路径仍可运行
- 至少验证：
  - allow
  - cross-chat reject
  - revoke reject
- 验收记录可追溯到 [phase2-real-e2e-report-2026-04-05.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/test-strategy/phase2-real-e2e-report-2026-04-05.md)

### 6. 发布说明模板

每个仓的 GitHub Release 说明至少包含：

- 模块职责
- 已冻结接口
- 已知边界
- 部署入口
- 回滚入口

### 7. 发布顺序

真正 cut alpha 版本时固定顺序：

1. `aily-skills-auth`
2. `aily-skills-auth-verify-sdk`
3. `aily-skills-auth-iam-service`
4. `aily-skills-auth-authcli`
5. `aily-skills-auth-demo-skill`

发布完成状态：

- 上述五个仓的 `v0.1.0-alpha` Release 已完成
- GHCR 镜像已推送：
  - `ghcr.io/wodenwang/aily-skills-auth-iam-service:0.1.0-alpha`
  - `ghcr.io/wodenwang/aily-skills-auth-demo-skill:0.1.0-alpha`

## Exit Criteria

以下条件同时满足，才允许进入真实 `v0.1.0-alpha` 发布动作：

- 文档冻结完成
- 打包命令验证完成
- 最小运行验证完成
- E2E 验证完成
- Release 说明模板准备完成

## Notes

- 当前仓内包元数据仍可在真正发布前统一改写
- 本清单不替代各子仓自己的 release / deployment 文档
