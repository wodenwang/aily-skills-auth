# Demo Skill Integration

## 目标

定义 `aily-skills-auth-demo-skill` 的双层定位：

- `skill-demo`：标准 skill 接入样板，负责先调用 `authcli`
- `service-demo`：最小受保护业务服务，负责接入 `verify-sdk`

两者组合后，形成完整联调路径：入站依赖 `authcli`，服务端验证依赖 `verify-sdk` 和 `iam-service`。

## 最小链路

1. Agent 接收飞书消息
2. `skill-demo` 调用 `auth-cli check --skill <skill_id> --format json`
3. `authcli` 命中缓存或向 IAM Service 请求 token
4. `skill-demo` 读取 `authcli` 输出并决定是否继续调用
5. allow 时携带 token 和标准身份头调用 `service-demo`
6. `service-demo` 通过 `verify-sdk` 调用 `/api/v1/token/verify`
7. 验证通过后返回脱敏后的业务结果

## Skill Demo 最小伪代码

```bash
AUTH_JSON="$(auth-cli check --skill sales-analysis --format json)"

if jq -e '.ok == true and .allowed == true' >/dev/null <<<"$AUTH_JSON"; then
  ACCESS_TOKEN="$(jq -r '.access_token' <<<"$AUTH_JSON")"
  curl -X POST \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "X-Auth-User-ID: ou_abc123" \
    -H "X-Auth-Skill-ID: sales-analysis" \
    -H "X-Auth-Agent-ID: host-vm-a1b2c3d4" \
    -H "X-Aily-Chat-Id: oc_sales_weekly" \
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
X-Auth-Agent-ID: host-vm-a1b2c3d4
X-Aily-Chat-Id: oc_sales_weekly
```

## Phase 2 联调场景

- 私聊 allow：`skill-demo` 能拿到 token 并继续调用
- 允许群 allow：后端 API 的 Verify SDK 验证通过
- 未授权群 deny：`skill-demo` 必须立即退出，不调用 `service-demo`
- 刷新成功：缓存进入刷新窗口后，`authcli` 自动刷新并继续返回 token
- token 过期：`authcli` 放弃旧缓存，重新请求 `/api/v1/auth/check`
- 跨 chat 复用：服务端必须返回 `CHAT_CONTEXT_MISMATCH`
- revoke 后复用：服务端必须返回 `TOKEN_REVOKED`

## 联调关注点

- `authcli` 输出协议是否稳定
- `verify-sdk` 是否严格透传当前请求上下文
- deny 与 error 是否能被 `skill-demo` 区分
- 被拒绝时 Demo Skill 是否能友好反馈

## 模板沉淀方向

- 纯 Markdown 模板负责定义 `skill-demo` 的标准接入规范
- 最小 script reference 只作为模板的参考实现，不是模板本体
- `service-demo` 单独承担“受保护业务服务样板”的职责
