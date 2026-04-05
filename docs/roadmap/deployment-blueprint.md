# Deployment Blueprint

## 目标

为 `iam-service`、`verify-sdk` 集成方和 `authcli` 所在 Agent 宿主机提供一致的部署层级。

## POC

- 单节点部署
- Docker Compose
- PostgreSQL 单实例
- Redis 单实例
- 手动密钥管理

适用：

- 方案验证
- Demo Skill 联调

## Pilot

- K8s 小规模集群
- PostgreSQL 主备
- Redis 持久化
- Prometheus + Grafana
- 审计归档作业

适用：

- 试点部门接入
- 小规模并发

## Production

- 多节点 K8s
- 密钥轮换与 `kid` 管理
- Redis 高可用
- PostgreSQL 高可用
- 对象存储归档审计日志
- 告警与值班流程

## 关键指标

- `auth_success_rate`
- `auth_latency_p99`
- `token_verify_latency_p99`
- `identity_mismatch_count`
- `token_revocation_count`
- `cache_hit_rate`

## 运行约束

- IAM 服务仅内网暴露
- Agent 宿主机通过 HTTPS/mTLS 访问
- 敏感日志脱敏
- 撤销、密钥轮换、缓存失效需要有演练脚本
