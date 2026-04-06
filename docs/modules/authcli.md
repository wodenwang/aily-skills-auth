# AuthCLI

## 职责

- 采集运行时身份
- 调用 `/api/v1/auth/check`
- 缓存 token
- 处理刷新与过期重试
- 以稳定协议输出给 Skill 使用

## 所属仓库

- `aily-skills-auth-authcli`

## 技术栈

- Go

## 输入优先级

1. 显式参数
2. 环境变量
3. Agent 运行时上下文
4. 本地配置

## 最小输入字段

- `--skill`
- `--user-id`

可选兼容输入：

- `--format`
- `--context-file`

`agent_id`、`chat_id` 不再是 `0.2.0` 的核心授权输入。

## 输出格式

- `json`
- `env`
- `exit-code`

冻结细节见：

- [authcli-output.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/authcli-output.md)
- [token-cache.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-cache.md)

## 核心命令面

- `auth-cli check --skill <skill_id> --user-id <user_id>`

首版必须支持：

- `--skill`
- `--user-id`
- `--format`
- `--context-file`
- `--help`

## `--help` 验收要求

- 说明命令用途
- 说明输入来源优先级
- 说明输出格式
- 说明 deny 与 error 差异
- 说明缓存命中、刷新、失效语义
- 提供最小使用示例
- 说明安装与升级入口
- 提供标准命令示例：`auth-cli check --skill <skill_id> --user-id <user_id> --format json`

## 运行语义

- 命中未到刷新窗口的缓存时，直接返回缓存 token
- 命中进入刷新窗口但尚未过期的 token 时，先调用 `/api/v1/token/refresh`
- token 已过期或刷新失败时，重新调用 `/api/v1/auth/check`
- deny、上游异常、上下文缺失都必须 fail-closed

## 分发要求

- 不作为长期驻留服务部署
- 优先提供简单安装和升级入口
- 推荐支持 `curl | sh` 或等价远程脚本分发方式

## `0.2.0` 依赖

- `aily-skills-auth-iam-service`
- `aily-skills-auth-demo-skill`

## 测试重点

- 输入优先级稳定
- 缓存命中、刷新、失效规则稳定
- 三种输出协议稳定
- `--help` 文案完整且可回归

## 边界

- 不评估策略
- 不保存长期用户凭据
- 不绕过 IAM Service 自行发 token
