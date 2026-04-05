# AuthCLI MVP Bootstrap

## 目标

在 `aily-skills-auth-iam-service` 已能稳定提供最小鉴权接口后，启动 `aily-skills-auth-authcli`，完成 Phase 1 的本地鉴权闭环。

## 启动前检查

- `/api/v1/auth/check` 已按冻结契约返回 allow 或 deny
- `/api/v1/token/refresh` 已按冻结契约返回刷新结果
- JWT claims 与 [domain-model.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/contracts/domain-model.md) 对齐
- 审计最小字段可落库

## 子仓第一批文件

- `README.md`
- `AGENTS.md`
- `docs/contracts/authcli-output.md`
- `docs/contracts/token-cache.md`
- `docs/test-plan.md`

模板来源：

- [authcli-readme-template.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/authcli-readme-template.md)
- [authcli-agents-template.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/authcli-agents-template.md)
- [test-plan-template.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/templates/test-plan-template.md)

## 第一批实现范围

- `check` 命令
- 四元组身份采集
- 本地 token 缓存
- 刷新窗口判断
- `/api/v1/auth/check` 与 `/api/v1/token/refresh` 客户端
- `json` / `env` / `exit-code` 输出

## 明确不做

- 策略本地计算
- 长期凭据托管
- 多语言 SDK
- 管理控制台页面
- `verify-sdk` 的服务端校验链路

## 联调顺序

1. 使用固定输入直连 `iam-service`
2. 验证 allow、deny、refresh 三类主路径
3. 接入 `demo-skill` 验证端到端调用
4. 再补 CLI 行为测试和失败关闭测试
