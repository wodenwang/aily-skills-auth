# Repo Splitting Plan

## 原则

- 一个子仓对应一个清晰职责边界
- 主控仓只维护标准，不承载过渡实现
- 跨仓接口先在主控仓冻结，再下发实现

## 仓库列表

### `aily-skills-auth`

- 类型：主控规划/模板仓
- 内容：V3、模板、契约、测试策略、注册表、示例

### `aily-skills-auth-iam-service`

- 类型：核心服务仓
- 内容：FastAPI 应用、数据库迁移、同步任务、策略引擎、JWT、审计

### `aily-skills-auth-admin-console`

- 类型：前端仓
- 内容：React SPA、管理页面、策略模拟器、审计查询

### `aily-skills-auth-authcli`

- 类型：CLI 仓
- 内容：Go 命令行工具、缓存、身份探测、注册与鉴权请求

### `aily-skills-auth-verify-sdk`

- 类型：SDK 仓
- 内容：验证中间件、JWT 校验、缓存、撤销同步

### `aily-skills-auth-demo-skill`

- 类型：示例仓
- 内容：Demo Skill、联调脚本、回归样例

## 创建顺序

1. `aily-skills-auth`
2. `aily-skills-auth-iam-service`
3. `aily-skills-auth-authcli`
4. `aily-skills-auth-demo-skill`
5. `aily-skills-auth-verify-sdk`
6. `aily-skills-auth-admin-console`

## 依赖关系

- `authcli` 首先依赖 `iam-service`
- `demo-skill` 依赖 `authcli`
- `verify-sdk` 依赖 `iam-service` 的冻结契约
- `admin-console` 依赖 `iam-service` 管理 API

## 不允许的拆分方式

- 把所有实现塞进一个 monorepo 再拆
- 把 SDK 合并进 `iam-service`
- 把策略引擎逻辑分散到 `authcli` 或 `verify-sdk`
