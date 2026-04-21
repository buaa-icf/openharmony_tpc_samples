# Local Submodule Patches

存放针对 `submodules/` 下各子模块的本地修改。构建时由 `library/src/main/cpp/CMakeLists.txt` 自动应用（调用 `apply_patches.sh`）。

## 目录约定

```
patches/
├── apply_patches.sh          # 应用脚本（幂等）
└── <submodule-name>/
    └── NNNN-<desc>.patch     # 使用 git diff 生成
```

## 应用时机

每次 CMake 配置阶段都会调用 `apply_patches.sh`，它会：
- 先用 `git apply --reverse --check` 检测 patch 是否已应用 → 跳过
- 否则用 `git apply --check` 校验，再应用
- 应用失败（上游已改动）会报错并提示重新生成 patch

## 新增 patch

在子模块里修改文件后：

```bash
cd submodules/rive-runtime
git diff path/to/file > ../../patches/rive-runtime/NNNN-<desc>.patch
```

## 现有 patch

### rive-runtime/0001-skip-macos-metallib-for-non-apple-targets.patch

`renderer/premake5_pls_renderer.lua` 在 macOS 宿主上无条件追加 `rive_pls_macosx_metallib` 构建目标，导致交叉编译 OHOS 时仍会调用 `xcrun metal`（依赖完整 Xcode）。修复为仅在目标平台是 macOS/iOS 时才编译 Metal 库。
