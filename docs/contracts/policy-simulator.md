# Policy Simulator Contract

## Status

- `0.2.0` future / deferred
- 非当前冻结接口

## Purpose

策略模拟器不纳入 `0.2.0` 的 `admin-console` MVP。

实现仓在 `0.2.0` 不应把本文档视为必须实现的当前 contract。

本文件保留为后续版本占位，用于说明未来若重新引入模拟器，必须遵守以下边界：

- 模拟器只能调用服务端能力
- 前端不重算授权策略
- 结果必须可映射到真实鉴权错误码和审计字段

## Future Direction

若后续恢复模拟器，输入模型应基于当时冻结的授权主模型重新定义。

在 `0.2.0` 之后重新设计前，不保留以下旧模型假设：

- `agent_id`
- `chat_id`
- `role`
- `data_scope`
- `permissions`
