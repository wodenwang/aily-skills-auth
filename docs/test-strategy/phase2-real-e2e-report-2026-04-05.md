# Phase 2 Real E2E Report

## Summary

- Report time: `2026-04-06 00:01:20 CST`
- Scope: `authcli -> demo-skill -> verify-sdk -> iam-service`
- Execution mode: local real services and real CLI
- IAM health: `GET http://127.0.0.1:8000/healthz -> 200 OK`
- Service demo health: `GET http://127.0.0.1:9000/healthz -> 200 OK`

本次报告用于确认 Phase 2 的真实闭环已经成立，且 `admin-console` 延后不会阻塞当前试点准备。

## Environment

- `aily-skills-auth-iam-service`
  - PostgreSQL / Redis 通过 `docker compose` 运行
  - 服务进程以 `SEED_DEMO_DATA=true STORE_BACKEND=database` 启动
- `aily-skills-auth-demo-skill`
  - 本地 `uv run uvicorn demo_skill.app:app --host 127.0.0.1 --port 9000`
- `aily-skills-auth-authcli`
  - 通过 `go run ./cmd/auth-cli` 被 `scripts/run_real_e2e.py` 直接调用
- `aily-skills-auth-verify-sdk`
  - 作为 `demo-skill` 的真实依赖参与验证

固定联调身份：

- `user_id=ou_abc123`
- `skill_id=sales-analysis`
- `agent_id=host-vm-a1b2c3d4`
- allow chat: `oc_sales_weekly`
- wrong chat: `oc_random_group`

## Executed Commands

跨四仓真实 E2E：

```bash
uv run python scripts/run_real_e2e.py
```

`authcli` 真实 IAM 补充验证：

```bash
AUTHCLI_REAL_IAM_BASE_URL=http://127.0.0.1:8000 go test ./internal/app -run 'TestRealIAM(GroupDeny|RefreshWindowRefreshesAndUpdatesCache|PrivateAllow)$' -v
```

## Results

| Case ID | Scenario | Result | Evidence |
|---------|----------|--------|----------|
| E2E-01 | allow path | PASS | `service-demo` 返回 `200`，并透传 `jti/user_id/skill_id/agent_id/chat_id` 与 `query/result` |
| E2E-02 | cross-chat reuse denied | PASS | `demo-skill` 返回 `403`，`failure_code=CHAT_CONTEXT_MISMATCH` |
| E2E-03 | revoke then reuse denied | PASS | `/api/v1/token/revoke` 返回 `revoked=true`，后续访问 `403` 且 `failure_code=TOKEN_REVOKED` |
| UAT-01 | authcli private allow | PASS | `TestRealIAMPrivateAllow` 通过 |
| UAT-02 | authcli deny | PASS | `TestRealIAMGroupDeny` 通过 |
| UAT-03 | authcli refresh | PASS | `TestRealIAMRefreshWindowRefreshesAndUpdatesCache` 通过 |

## Output Snapshot

真实 E2E 输出：

```json
{
  "ok": true,
  "allow": {
    "ok": true,
    "request_auth": {
      "jti": "a9053219bf5c48e19423fb7bb63257e9",
      "user_id": "ou_abc123",
      "skill_id": "sales-analysis",
      "agent_id": "host-vm-a1b2c3d4",
      "chat_id": "oc_sales_weekly"
    },
    "permissions": [
      "sales:read"
    ],
    "data_scope": {
      "data_level": "none",
      "dept_ids": [
        "D001"
      ]
    },
    "query": "sales summary",
    "result": "demo response"
  },
  "cross_chat_reject": {
    "ok": false,
    "failure_code": "CHAT_CONTEXT_MISMATCH",
    "message": "token verification denied"
  },
  "revoke": {
    "revoked": true,
    "jti": "a9053219bf5c48e19423fb7bb63257e9",
    "failure_code": null
  },
  "revoked_reject": {
    "ok": false,
    "failure_code": "TOKEN_REVOKED",
    "message": "token verification denied"
  }
}
```

`authcli` 真实 IAM 补充输出：

```text
=== RUN   TestRealIAMPrivateAllow
--- PASS: TestRealIAMPrivateAllow (0.12s)
=== RUN   TestRealIAMGroupDeny
--- PASS: TestRealIAMGroupDeny (0.02s)
=== RUN   TestRealIAMRefreshWindowRefreshesAndUpdatesCache
--- PASS: TestRealIAMRefreshWindowRefreshesAndUpdatesCache (0.14s)
PASS
ok  	aily-skills-auth-authcli/internal/app	1.113s
```

## Conclusion

- Phase 2 的真实技术闭环已经成立：
  - `authcli` 能稳定获取和刷新 token
  - `verify-sdk` 能强制执行上下文一致性校验
  - `demo-skill` 能以 `POST /api/demo/query` 证明跨四仓真实请求链路
  - `iam-service` 能稳定返回 `CHAT_CONTEXT_MISMATCH` 和 `TOKEN_REVOKED`
- `admin-console` 延后不会阻塞当前试点准备。

## Remaining Gaps For Phase 3

- 还缺试点 Skill 的真实接入报告
- 还缺监控指标、告警规则和演练脚本文档
- 还缺部署、回滚和审计排障手册
