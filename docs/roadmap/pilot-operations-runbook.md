# Pilot Operations Runbook

## Goal

为首个试点 Skill 提供不依赖 `admin-console` 的最小运行手册，覆盖部署、监控、告警、演练和回滚。

## Pilot Scope

当前试点固定使用以下四个实现仓：

- `aily-skills-auth-iam-service`
- `aily-skills-auth-authcli`
- `aily-skills-auth-verify-sdk`
- `aily-skills-auth-demo-skill`
  - 其中试点前主要复用 `skill-template`、`service-demo`

当前不纳入试点关键路径：

- `aily-skills-auth-admin-console`

## Recommended Deployment Shape

本手册与 [deployment-blueprint.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/deployment-blueprint.md) 的关系如下：

- `0.2.0` 默认基线是 POC 级 Compose 形态
- 试点阶段可以在不改变公共契约的前提下演进到小规模 K8s
- 若进入 K8s，必须保留与 Compose 基线一致的服务边界、鉴权接口和分发方式

### IAM Service

- 部署形态：默认采用 `iam-service + PostgreSQL + Redis` 同一 Compose 单元；试点规模扩大后可演进到小规模 K8s
- 依赖：PostgreSQL、Redis
- 启动前要求：
  - 数据库迁移已执行
  - JWT 密钥已准备
  - 审计落库已开启

### AuthCLI

- 部署形态：随 Agent 宿主机安装
- 运行要求：
  - 能访问 IAM 内网地址
  - 本地缓存路径可写
  - 超时和失败关闭保持默认开启
  - 推荐安装入口为 `curl | sh` 或等价远程脚本拉取方式

### Verify SDK

- 部署形态：作为业务后端依赖安装
- 运行要求：
  - 强制开启 Bearer token 校验
  - 强制传 `X-Auth-User-ID`
  - 强制传 `X-Auth-Skill-ID`
  - 通过标准包分发方式安装和升级，不作为独立 Compose 服务

### Skill Sample / Pilot Skill

- 部署形态：独立后端服务
- 运行要求：
  - 入站必须先调用 `auth-cli check`
  - 出站调用 `service-demo` 或真实业务服务时必须携带 token 和标准身份头

## Pilot Acceptance Checklist

- allow 路径稳定
- deny 路径稳定
- refresh 路径稳定
- identity mismatch 被拒绝
- revoke 后复用被拒绝
- 审计记录可查询
- 失败时能定位到 `request_id`

## Monitoring

### Required Metrics

- `auth_success_rate`
- `auth_latency_p99`
- `token_verify_latency_p99`
- `identity_mismatch_count`
- `token_revocation_count`
- `cache_hit_rate`

### Required Dashboards

- IAM 请求量、成功率、延迟
- verify 拒绝码分布
- token revoke 频率
- `authcli` 缓存命中率
- 试点 Skill 请求量与失败率

## Alert Rules

### P1 Alerts

- `identity_mismatch_count > 0`
- `token_verify_latency_p99` 持续超阈值
- `auth_success_rate` 突降

### P2 Alerts

- `token_revocation_count` 异常升高
- `cache_hit_rate` 异常下降
- `authcli` 上游失败率升高

## Drill Procedures

### Revoke Drill

1. 使用 allow 用户获取 token
2. 业务请求通过一次 verify
3. 调用撤销接口
4. 再次复用旧 token
5. 确认返回 `TOKEN_REVOKED`
6. 确认审计与告警可见

### Key Rotation Drill

1. 准备新的 `kid`
2. 在 IAM 发布新公私钥对
3. 保持旧公钥一段兼容窗口
4. 验证新签发 token 可通过 verify
5. 验证旧 token 在兼容窗口内仍可验证
6. 兼容窗口结束后移除旧 key

### Cache Invalidation Drill

1. 使用 `authcli` 获取 token 并落本地缓存
2. 人工触发 revoke 或让 token 进入失效条件
3. 再次运行 `authcli check`
4. 确认旧缓存不被错误复用
5. 确认刷新或重新鉴权行为符合冻结契约

## Rollback

### IAM Service

- 回滚到上一版本镜像或提交
- 恢复上一版环境变量和 key 配置
- 如涉及迁移，优先回滚应用，再评估数据库兼容性

### Pilot Skill

- 回滚业务服务版本
- 保持 `authcli` 和 `verify-sdk` 契约不变
- 若本次发布涉及标准头传递变更，优先回滚该变更

## Troubleshooting

- allow 失败：
  - 先查 `authcli` stderr 和 `request_id`
  - 再查 IAM access log 和 audit log
- verify 拒绝：
  - 先确认 token 是否过期或已撤销
  - 再确认 `user_id / skill_id` 是否与 token `sub/aud` 一致
- 试点 Skill 无法访问后端：
  - 先查 `verify-sdk` 依赖是否正确安装
  - 再查 IAM 地址和网络策略
