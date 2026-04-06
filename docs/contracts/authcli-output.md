# AuthCLI Output Contract

## Commands

- `auth-cli check`
- `auth-cli check --help`

`0.2.0` 首先冻结 `check` 命令的输出协议和 `--help` 应覆盖的最小信息面。

## Input Fields

固定输入字段：

- `user_id`
- `skill_id`

可选兼容字段：

- `context_file`

输入优先级：

1. 显式参数
2. 环境变量
3. Agent 运行时上下文
4. 本地配置

## Formats

- `json`
- `env`
- `exit-code`

未显式指定时默认输出 `json`。

## JSON Success

```json
{
  "ok": true,
  "request_id": "req_abc123",
  "allowed": true,
  "token_type": "Bearer",
  "access_token": "eyJ...",
  "expires_in": 300,
  "refresh_before": 240,
  "cache_hit": false,
  "auth_context": {
    "user_id": "ou_abc123",
    "skill_id": "sales-analysis"
  }
}
```

## JSON Denied

```json
{
  "ok": false,
  "request_id": "req_abc123",
  "allowed": false,
  "deny_code": "GRANT_NOT_ACTIVE",
  "deny_message": "该用户当前未获得此 Skill 的有效授权"
}
```

## ENV Success

```bash
AUTH_OK=true
AUTH_ALLOWED=true
AUTH_REQUEST_ID=req_abc123
AUTH_TOKEN_TYPE=Bearer
AUTH_ACCESS_TOKEN=eyJ...
AUTH_EXPIRES_IN=300
AUTH_REFRESH_BEFORE=240
AUTH_USER_ID=ou_abc123
AUTH_SKILL_ID=sales-analysis
```

## ENV Denied

```bash
AUTH_OK=false
AUTH_ALLOWED=false
AUTH_REQUEST_ID=req_abc123
AUTH_DENY_CODE=GRANT_NOT_ACTIVE
AUTH_DENY_MESSAGE=该用户当前未获得此 Skill 的有效授权
```

## Exit Codes

- `0`: allowed
- `10`: denied by policy
- `20`: invalid input
- `30`: cache read/write failure
- `40`: upstream unavailable or timeout
- `50`: unexpected internal error

## `--help` Minimum Coverage

帮助文案必须至少说明：

- 命令用途
- 最小输入要求
- 输入优先级
- 输出格式
- deny 与 error 的区别
- 缓存命中、刷新、失效行为
- 最小示例
- 安装升级入口约定
- 标准命令示例：`auth-cli check --skill <skill_id> --user-id <user_id> --format json`

## Rules

- deny 和 error 必须区分，禁止把上游异常伪装成 deny
- 任一错误场景必须 fail-closed，不输出伪造 token
- `env` 模式仅在 allow 场景输出 token 字段
- `json` 和 `env` 都必须保留 `request_id` 以便审计串联
