# AGENTS

## Repo Role

本仓库只实现 `authcli` 本地鉴权能力，不承载服务端策略计算、管理控制台或 Verify SDK。

## Document Priority

1. `AGENTS.md`
2. `README.md`
3. `docs/contracts/**`
4. `docs/**`

## Ownership

- Lead: 维护仓库边界与版本节奏
- Runtime: 维护命令行行为、缓存与重试
- API: 维护 IAM 接口客户端与错误映射
- Quality: 维护 CLI 行为测试与联调样例

## Frozen Interfaces

- `POST /api/v1/auth/check`
- `POST /api/v1/token/refresh`
- AuthCLI 输出协议
- Token 缓存文件格式与失效规则

## Definition of Done

- `check` 命令可稳定运行
- allow、deny、refresh 三类主路径可回归
- fail-closed 行为稳定
- 输出协议和缓存协议无漂移
