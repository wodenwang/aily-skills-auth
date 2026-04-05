# `0.1.0-alpha` Cloud-Equivalent Rehearsal Report

## Goal

使用已经正式发布的 `0.1.0-alpha` 制品完成一轮云端等价部署演练，确认：

- GHCR 发布镜像可直接启动
- GitHub Release 发布二进制可直接运行
- `verify-sdk -> service-demo` 的制品依赖顺序成立
- allow / cross-chat / revoke 三条真实链路可继续通过

## Artifact Coordinates

### `iam-service`

- image: `ghcr.io/wodenwang/aily-skills-auth-iam-service:0.1.0-alpha`
- digest: `sha256:761c51d0b36e4ce3a28ae3b86b4836252173046782567efac62e0317685bc99a`

### `service-demo`

- image: `ghcr.io/wodenwang/aily-skills-auth-demo-skill:0.1.0-alpha`
- digest: `sha256:e8660f2dc51fe2d2ecbdebf3c0cc0e5a0627542ea66851a2316c250110513543`

### `authcli`

- release asset: `auth-cli-darwin-arm64.tar.gz`
- source: [wodenwang/aily-skills-auth-authcli v0.1.0-alpha](https://github.com/wodenwang/aily-skills-auth-authcli/releases/tag/v0.1.0-alpha)

### `verify-sdk`

- release asset: `aily_skills_auth_verify_sdk-0.1.0a0-py3-none-any.whl`
- source: [wodenwang/aily-skills-auth-verify-sdk v0.1.0-alpha](https://github.com/wodenwang/aily-skills-auth-verify-sdk/releases/tag/v0.1.0-alpha)

## Rehearsal Shape

这次演练使用：

- 本地 PostgreSQL / Redis 容器模拟托管依赖
- GHCR 已发布镜像运行 `iam-service` 与 `service-demo`
- GitHub Release 已发布二进制运行 `authcli`
- 当前仓的 E2E 脚本验证 released artifacts 组合

## Executed Steps

### 1. 拉取正式镜像

```bash
docker pull ghcr.io/wodenwang/aily-skills-auth-iam-service:0.1.0-alpha
docker pull ghcr.io/wodenwang/aily-skills-auth-demo-skill:0.1.0-alpha
```

### 2. 准备数据库和缓存

```bash
cd /Users/wenzhewang/workspace/codex/aily-skills-auth-iam-service
docker compose up -d postgres redis
```

### 3. 预迁移数据库

```bash
cd /Users/wenzhewang/workspace/codex/aily-skills-auth-iam-service
SEED_DEMO_DATA=true STORE_BACKEND=database uv run alembic upgrade head
```

### 4. 启动正式发布镜像

```bash
docker run -d --rm --name aily-auth-alpha-iam -p 18000:8000 \
  -e APP_PORT=8000 \
  -e DATABASE_URL=postgresql+psycopg://aily_auth:aily_auth@host.docker.internal:5432/aily_auth_iam \
  -e POSTGRES_HOST=host.docker.internal \
  -e REDIS_HOST=host.docker.internal \
  -e STORE_BACKEND=database \
  -e SEED_DEMO_DATA=true \
  -e JWT_PRIVATE_KEY_PATH=/tmp/runtime/keys/jwt-private.pem \
  -e JWT_PUBLIC_KEY_PATH=/tmp/runtime/keys/jwt-public.pem \
  ghcr.io/wodenwang/aily-skills-auth-iam-service:0.1.0-alpha

docker run -d --rm --name aily-auth-alpha-demo -p 19000:9000 \
  -e AILY_IAM_BASE_URL=http://host.docker.internal:18000 \
  ghcr.io/wodenwang/aily-skills-auth-demo-skill:0.1.0-alpha
```

### 5. 健康检查

```bash
curl -fsS http://127.0.0.1:18000/healthz
curl -fsS http://127.0.0.1:19000/healthz
```

结果：

- `{"status":"ok"}`
- `{"status":"ok"}`

### 6. 使用正式 `authcli` 制品跑真实 E2E

```bash
gh release download v0.1.0-alpha \
  --repo wodenwang/aily-skills-auth-authcli \
  -D /tmp/authcli-alpha \
  --pattern 'auth-cli-*.tar.gz'

tar -xzf /tmp/authcli-alpha/auth-cli-darwin-arm64.tar.gz -C /tmp/authcli-alpha/bin

cd /Users/wenzhewang/workspace/codex/aily-skills-auth-demo-skill
AUTHCLI_BIN=/tmp/authcli-alpha/bin/auth-cli-darwin-arm64 \
AILY_IAM_BASE_URL=http://127.0.0.1:18000 \
DEMO_SKILL_BASE_URL=http://127.0.0.1:19000 \
uv run python scripts/run_real_e2e.py
```

## Result

结果：通过

关键输出：

- allow: 通过
- cross-chat reject: `CHAT_CONTEXT_MISMATCH`
- revoke reject: `TOKEN_REVOKED`

## Important Caveat

当前 `iam-service` 的正式镜像没有内置数据库迁移入口，因此本次演练仍使用了源码仓的 `alembic upgrade head` 做预迁移。

这意味着：

- 运行态制品已经可用
- 但如果要进入真正的云端标准化部署，仍建议补一个正式的迁移执行入口：
  - 独立 migration image
  - 或镜像内显式包含 alembic 资源和启动命令

## Decision

`0.1.0-alpha` 已具备“正式制品可运行”的基础条件：

- 发布镜像可拉取
- 发布二进制可执行
- 发布依赖顺序成立
- 真实 E2E 可通过

下一步应进入首个真实试点 skill 接入。
