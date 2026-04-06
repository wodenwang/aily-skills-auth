# Demo Skill Integration

## 目标

定义 `aily-skills-auth-demo-skill` 在 `0.2.0` 的双层定位：

- `skill-template`：标准 Skill Markdown 样板，负责清楚说明先调用 `authcli`
- `service-demo`：最小受保护业务服务样板，负责清楚说明如何接入 `verify-sdk`

两者组合后，形成完整联调路径：入站依赖 `authcli`，服务端验证依赖 `verify-sdk` 和 `iam-service`。

## 双样板边界

### `skill-template`

只负责说明：

- `auth-cli check --skill <skill_id> --user-id <user_id> --format json`
- 如何读取 `access_token`
- 如何带 `Authorization`、`X-Auth-User-ID`、`X-Auth-Skill-ID`
- deny 和 error 时如何 fail-closed

不负责说明：

- 具体业务场景映射
- 服务参数细节
- 大段业务脚本

这些内容应放到 `reference` 或 `scripts`。

### `service-demo`

只负责说明：

- 一个服务端核心业务逻辑如何接 `verify-sdk`
- 如何把 token 和标准身份头交给 SDK
- 验证通过后如何拿到最小鉴权上下文

## 最小链路

1. Agent 接收用户请求
2. Skill 先调用 `auth-cli check --skill <skill_id> --user-id <user_id> --format json`
3. `authcli` 命中缓存或向 IAM Service 请求 token
4. Skill 读取 `authcli` 输出并决定是否继续调用
5. allow 时携带 token 和标准身份头调用 `service-demo`
6. `service-demo` 通过 `verify-sdk` 调用 `/api/v1/token/verify`
7. 验证通过后返回业务结果

## Skill Demo 最小伪代码

```bash
AUTH_JSON="$(auth-cli check --skill sales-analysis --user-id ou_abc123 --format json)"

if jq -e '.ok == true and .allowed == true' >/dev/null <<<"$AUTH_JSON"; then
  ACCESS_TOKEN="$(jq -r '.access_token' <<<"$AUTH_JSON")"
  curl -X POST \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "X-Auth-User-ID: ou_abc123" \
    -H "X-Auth-Skill-ID: sales-analysis" \
    -H "Content-Type: application/json" \
    -d '{"query":"sales summary"}' \
    http://127.0.0.1:9000/api/demo/query
else
  jq -r '.deny_message // "auth failed"' <<<"$AUTH_JSON" >&2
  exit 10
fi
```

## Service Demo 接收的标准请求头

```http
Authorization: Bearer eyJ...
X-Auth-User-ID: ou_abc123
X-Auth-Skill-ID: sales-analysis
```

## `0.2.0` 联调场景

- allow：Skill 能拿到 token 并继续调用
- deny：Skill 必须立即退出，不调用 `service-demo`
- 刷新成功：缓存进入刷新窗口后，`authcli` 自动刷新并继续返回 token
- token 过期：`authcli` 放弃旧缓存，重新请求 `/api/v1/auth/check`
- 身份不一致：服务端必须返回 `IDENTITY_MISMATCH`
- revoke 后复用：服务端必须返回 `TOKEN_REVOKED`

## 模板沉淀方向

- 纯 Markdown 模板负责定义 Skill 的标准接入规范
- 最小 script reference 只作为模板参考实现，不是模板本体
- `service-demo` 单独承担“受保护业务服务样板”的职责
