# Deployment Blueprint

## 目标

为 `iam-service`、`verify-sdk` 集成方、`authcli` 分发和 `demo-service` 提供一致的 `0.2.0` 部署基线。

## `0.2.0` 默认部署拆分

### IAM Compose 单元

以下组件固定在同一个 Compose 拓扑中：

- `iam-service`
- PostgreSQL
- Redis

原因：

- 三者高聚合
- 便于单机 POC、联调和首轮运维
- 便于统一管理迁移、缓存和服务配置

### Demo Compose 单元

以下组件可保持独立 Compose：

- `service-demo`

原因：

- 便于单独演示受保护业务服务接入
- 便于与真实业务服务替换

### 非 Compose 分发对象

以下组件不作为 Compose 服务发布：

- `authcli`
- `verify-sdk`

分发要求：

- `authcli` 支持简单安装与升级入口，优先 `curl | sh` 或等价脚本拉取方式
- `verify-sdk` 通过标准包分发方式供服务端安装和升级

## POC

- 单节点部署
- `iam-service + PostgreSQL + Redis` 同一 Compose
- `service-demo` 独立 Compose
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
