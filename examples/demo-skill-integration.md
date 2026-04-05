# Demo Skill Integration

## 目标

定义 `aily-skills-auth-demo-skill` 的最小联调路径。

## 最小链路

1. Agent 接收飞书消息
2. Demo Skill 调用 `auth-cli check --skill <skill_id> --format json`
3. IAM Service 返回 token
4. Demo Skill 携带 token 调用受保护 API
5. Verify SDK 验证通过
6. 返回脱敏后的业务结果

## 示例请求头

```http
Authorization: Bearer eyJ...
X-Auth-User-ID: ou_abc123
X-Auth-Skill-ID: sales-analysis
X-Auth-Agent-ID: host-vm-a1b2c3d4
```

## 联调关注点

- AuthCLI 输出协议是否稳定
- Verify SDK 是否严格校验身份一致性
- 被拒绝时 Demo Skill 是否能友好反馈
