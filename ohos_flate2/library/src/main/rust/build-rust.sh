#!/usr/bin/env bash
set -e

# 1. 定义要支持的 ABI 列表
declare -A TARGETS=(
  ["arm64-a"]="aarch64-unknown-linux-ohos"
  ["x86"]="x86_64-unknown-linux-ohos"
)


# 2. 确保 target 已安装
for ABI in "${!TARGETS[@]}"; do
  TARGET="${TARGETS[$ABI]}"

    rustup target add "$TARGET"

done

# 3. 执行构建命令
ohrs build --release --arch arm64 --arch x64 --dist ../../../libs
