# AuthCLI

## 职责

- 采集运行时身份
- 调用 `/api/v1/auth/check`
- 缓存 token
- 处理刷新与过期重试
- 输出给 Skill 使用

## 所属仓库

- `aily-skills-auth-authcli`

## 技术栈

- Go

## 输入优先级

1. 显式参数
2. 环境变量
3. Agent 运行时上下文
4. 本地配置

## 输出格式

- `json`
- `env`
- `exit-code`

冻结细节见：

- [authcli-output.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/authcli-output.md)
- [token-cache.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/token-cache.md)

## MVP 命令面

- `auth-cli check --skill <skill_id>`

首版必须支持：

- `--skill`
- `--user-id`
- `--agent-id`
- `--chat-id`
- `--format`
- `--context-file`

## 运行语义

- 命中未到刷新窗口的缓存时，直接返回缓存 token
- 命中进入刷新窗口但尚未过期的 token 时，先调用 `/api/v1/token/refresh`
- token 已过期或刷新失败时，重新调用 `/api/v1/auth/check`
- deny、上游异常、上下文缺失都必须 fail-closed

## Phase 1 依赖

- `aily-skills-auth-iam-service`
- `aily-skills-auth-demo-skill`

## 测试重点

- 输入优先级稳定
- 缓存命中、刷新、失效规则稳定
- 三种输出协议稳定
- 私聊 allow、群聊 deny、过期重试可回归

## 边界

- 不评估策略
- 不保存长期用户凭据
- 不绕过 IAM Service 自行发 token
