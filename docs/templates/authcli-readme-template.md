# Aily Skills AuthCLI

## Purpose

本仓库实现企业 Agent Skill 鉴权平台的本地鉴权 CLI，负责身份采集、鉴权请求、token 缓存与刷新，以及向 Skill 输出稳定协议。

## Scope

- In scope:
  - `auth-cli check`
  - 四元组身份采集
  - 本地 token 缓存与刷新
  - `/api/v1/auth/check`、`/api/v1/token/refresh` 客户端
  - `json` / `env` / `exit-code` 输出
- Out of scope:
  - 本地策略计算
  - JWT 服务端验证
  - 管理端页面

## Frozen Inputs And Outputs

- Inputs:
  - 显式参数
  - 环境变量
  - Agent 运行时上下文
  - 本地配置
- Outputs:
  - `json`
  - `env`
  - `exit-code`
- Dependencies:
  - `aily-skills-auth-iam-service`

## Local Development

记录构建、测试、样例联调命令。
