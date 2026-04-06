# Aily Skills AuthCLI

## Purpose

本仓库实现企业 Agent Skill 鉴权平台的本地鉴权 CLI，负责身份采集、鉴权请求、token 缓存与刷新，以及向 Skill 输出稳定协议。

## Scope

- In scope:
  - `auth-cli check --skill <skill_id> --user-id <user_id>`
  - 最小输入模型：`user_id + skill_id`
  - 本地 token 缓存与刷新
  - `/api/v1/auth/check`、`/api/v1/token/refresh` 客户端
  - `json` / `env` / `exit-code` 输出
  - `--help` 帮助文案
- Out of scope:
  - 本地策略计算
  - JWT 服务端验证
  - 管理端页面

## Frozen Inputs And Outputs

- Inputs:
  - 显式参数，至少 `--skill`、`--user-id`
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

## Notes

- `agent_id`、`chat_id`、`appid` 不属于 `0.2.0` 的核心授权输入
- 若实现仓需要兼容旧参数，必须在子仓 `AGENTS.md` 中明确写出兼容边界，不能反向污染主控契约
