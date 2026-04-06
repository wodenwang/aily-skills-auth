# Skill Template Spec

## Purpose

本模板用于定义企业内一个“标准 Skill Markdown”如何接入 `authcli` 和受保护业务服务。

本模板是纯 Markdown 规范，用于冻结：

- Skill 元数据
- `authcli` 调用方式
- 下游关键服务请求头
- 失败处理
- 安全约束
- 验收清单

本模板不是可运行代码，也不承载业务参数细节。

如果需要参考实现，请使用：

- [minimal-skill-reference.sh](/Users/wenzhewang/workspace/codex/aily-skills-auth/examples/minimal-skill-reference.sh)

## 1. Skill Metadata

- `skill_id`:
- `skill_name`:
- `owner`:
- `business_purpose`:
- `protected_service`:

规则：

- `skill_id` 是冻结字段
- `skill_id` 必须与 IAM 注册信息一致
- 不允许在运行时动态改写 `skill_id`

## 2. AuthCLI Contract

Skill 在调用任何关键服务前，必须先调用：

```bash
auth-cli check --skill <skill_id> --user-id <user_id> --format json
```

允许依赖的 `authcli` 能力：

- 本地 access token 缓存
- refresh window 判断
- 过期重鉴权
- deny / upstream error 区分

禁止 Skill 自己实现：

- 本地 token 缓存
- token refresh
- 策略解释

## 3. AuthCLI Result Handling

Skill 必须至少区分三类结果：

### Allow

- `ok=true`
- `allowed=true`
- 读取 `access_token`
- 继续调用下游关键服务

### Deny

- `ok=false`
- `allowed=false`
- 读取 `deny_code`、`deny_message`
- 立即结束，不调用下游关键服务

### Error

- `authcli` 非 0 且非 deny 退出
- 或出现上游异常 / 输入异常 / 缓存异常
- 必须 fail-closed

规则：

- deny 和 error 必须分开处理
- 任一异常都不能伪造 allow

## 4. Downstream Request Contract

Skill 调用受保护业务服务时，必须透传：

```http
Authorization: Bearer <access_token>
X-Auth-User-ID: <user_id>
X-Auth-Skill-ID: <skill_id>
```

规则：

- `Authorization` 必须携带 `authcli` 返回的 access token
- `X-Auth-Skill-ID` 必须等于模板中的 `skill_id`
- Skill 不允许省略任一标准头

## 5. What Belongs In Skill Markdown

Skill Markdown 只说明：

- 先执行 `auth-cli check`
- 成功后如何读取 `access_token`
- 如何以标准头调用关键服务
- deny / error 时如何 fail-closed

以下内容不应写入 Skill Markdown 主模板：

- 具体业务场景映射
- 下游服务参数细节
- 复杂业务请求示例
- reference 级别的脚本说明

这些内容应下沉到 `reference` 或 `scripts`。

## 6. Failure Handling

Skill 对下游业务服务返回至少要识别：

- `TOKEN_REVOKED`
- `TOKEN_EXPIRED`
- `IDENTITY_MISMATCH`

默认处理：

- `TOKEN_REVOKED`: 立即拒绝，提示重新鉴权
- `TOKEN_EXPIRED`: 立即结束当前请求，由上层重新发起一次完整调用
- `IDENTITY_MISMATCH`: 立即拒绝并记录高优先级错误

规则：

- Skill 不自行修复身份错误
- Skill 不重试身份不一致类错误

## 7. Security Rules

- 不允许跳过 `authcli`
- 不允许本地保存长期用户凭据
- 不允许本地重算权限
- 不允许修改或伪造标准身份头
- 日志中不允许输出完整 token

## 8. Minimal Sequence

1. 收到用户请求
2. 收集 `user_id`
3. 调用 `auth-cli check`
4. deny 或 error 则立即结束
5. allow 则读取 `access_token`
6. 调用受保护业务服务，并透传标准头
7. 返回业务结果

## 9. Acceptance Checklist

- allow 路径通过
- deny 路径通过
- refresh 路径不破坏主调用
- 过期 token 不被错误复用
- revoke 后复用被拒绝
- 标准头完整
- 日志不泄露完整 token
- 失败时可关联 `request_id`
