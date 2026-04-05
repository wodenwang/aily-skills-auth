# `0.1.0-alpha` Packaging Verification Report

## Goal

记录 `0.1.0-alpha` 发布前的首轮打包命令验证结果。

本报告只覆盖打包命令和制品生成，不包含真实发布、tag 推送或 GitHub Release 上传。

## Version Semantics

- 仓库发布标签：`v0.1.0-alpha`
- 容器镜像标签：`0.1.0-alpha`
- Python 包元数据：`0.1.0a0`

说明：

- Python 包遵循 PEP 440，因此 `iam-service`、`verify-sdk`、`demo-skill` 的 wheel / sdist 使用 `0.1.0a0`
- 外部发布名称与 Git tag 继续保持 `0.1.0-alpha`

## Verification Results

### `aily-skills-auth-iam-service`

结果：通过

验证命令：

```bash
uvx --from build pyproject-build --wheel --sdist
docker build -t aily-skills-auth-iam-service:0.1.0-alpha .
```

结论：

- wheel / sdist 构建通过
- 镜像构建通过
- 仓内已补 `Dockerfile` 和 `.dockerignore`

### `aily-skills-auth-authcli`

结果：通过

验证命令：

```bash
GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build -trimpath -o dist/auth-cli-darwin-arm64 ./cmd/auth-cli
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -trimpath -o dist/auth-cli-linux-amd64 ./cmd/auth-cli
```

结论：

- Darwin arm64 二进制构建通过
- Linux amd64 二进制构建通过

### `aily-skills-auth-verify-sdk`

结果：通过

验证命令：

```bash
uvx --from build pyproject-build --wheel --sdist
```

结论：

- wheel / sdist 构建通过
- 包版本已对齐到 `0.1.0a0`

### `aily-skills-auth-demo-skill`

结果：通过

验证命令：

```bash
cd /Users/wenzhewang/workspace/codex/aily-skills-auth-verify-sdk
rm -rf dist
uvx --from build pyproject-build --wheel --sdist

cd /Users/wenzhewang/workspace/codex/aily-skills-auth-demo-skill
uvx --from build pyproject-build --wheel --sdist
docker build \
  --build-context verify_sdk_dist=../aily-skills-auth-verify-sdk/dist \
  --build-arg VERIFY_SDK_WHEEL=aily_skills_auth_verify_sdk-0.1.0a0-py3-none-any.whl \
  -t ghcr.io/org/aily-skills-auth-demo-skill:0.1.0-alpha \
  .
```

结论：

- wheel / sdist 构建通过
- `service-demo` 镜像构建通过
- `service-demo` 镜像按依赖顺序消费已构建的 `verify-sdk` wheel
- 镜像中不再复制 `verify-sdk` 源码副本

## Packaging Rule

`demo-skill` 的正式打包顺序已经固定为：

1. 先构建或先发布 `verify-sdk`
2. 再构建 `service-demo` 镜像

本地预发布验证使用 named build context 把 `verify-sdk/dist` 传入 `demo-skill` Dockerfile。

## Decision

当前打包链路已经满足主控仓 [alpha-release-readiness-checklist.md](/Users/wenzhewang/workspace/codex/aily-skills-auth/docs/roadmap/alpha-release-readiness-checklist.md) 中的“打包命令可执行”要求。

下一步可进入：

1. 最小运行验证
2. 发布说明模板收口
3. 是否真正 cut `v0.1.0-alpha` 的决策
