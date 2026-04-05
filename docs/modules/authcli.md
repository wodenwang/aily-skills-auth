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

## 边界

- 不评估策略
- 不保存长期用户凭据
- 不绕过 IAM Service 自行发 token
