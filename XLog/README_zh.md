# Xlog

简体中文 | [English](./README_en.md) *(敬请期待)*

> 面向 Harmony OS 的log模块。

## 项目简介

Xlog是一种在Harmony OS上的log模块
- 支持透明通道与遮罩混合渲染，可叠加在任意 UI 图层。
- 覆盖播放、暂停、静音、循环、逐帧 等全量控制。
- 提供 JSON/脚本驱动的动态元素替换，运行时更新头像、文案、音轨等。
- 支持软硬解码切换与 GPU 加速，可在真机与模拟器上保持一致体验。
- 统一 ArkTS API，适配 Stage Ability 生命周期与后台恢复策略。


## 下载安装

```bash
ohpm install @ohos/xlog
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)


## 使用说明

### 1. 引入组件与常量

```ts
import { Xlog, XLogConfig } from '@ohos/xlog';
```

### 2. 创建Xlog对象

```ts
let logPath: string = getContext().filesDir + "/xlog";
let cachePath: string = getContext().cacheDir + "/xlog";
let nameprefix: string = 'xlog_prefix';

let xlogConfig: XLogConfig = {
    level: Xlog.LEVEL_DEBUG,
    mode: Xlog.AppednerModeSync,
    logdir: logPath, # 一般使用沙箱files路径
    nameprefix: nameprefix,
    pubkey: "PUBKEY",
    compressmode: Xlog.ZLIB_MODE,
    compresslevel: Xlog.COMPRESS_LEVEL1,
    cachedir: cachePath,
    cachedays: 1
  };
let log = Xlog.fromLogConfig(xlogConfig);
```

### 3. 日志输出

参数依次是tag, 当前文件，当前函数，代码行数， 日志内容。
```ts
log.logV("unit_xlog", "uint.ets", "func", 114, "unit log info")
log.logI("unit_xlog", "uint.ets", "func", 114, "unit log info")
log.logD("unit_xlog", "uint.ets", "func", 114, "unit log info")
log.logE("unit_xlog", "uint.ets", "func", 114, "unit log info")
log.logF("unit_xlog", "uint.ets", "func", 114, "unit log info")
```

### 4. 设置输出到控制台
默认日志输出到文件。也可以设置日志同时输出到控制台。

```ts
log.setConsoleLogOpen(true)
```

### 5. 释放

```ts
log.release()
```

## 核心类与接口

### 核心类
| 名称           | 类型 | 作用                                              |
|--------------|----|-------------------------------------------------|
| `Xlog`       | 类  | 提供高内聚的创建、配置和输出接口。                               |
| `XLogConfig` | 接口 | 提供xlog配置参数, 包括日志配置级别、日志存储路径、缓存路径、压缩算法、压缩级别、缓存文件天数等。 |

### 核心配置参数
XLogConfig 提供了Xlog配置的参数，包括日志配置级别、日志存储路径、缓存路径、压缩算法、压缩级别、缓存文件天数等。

| 属性              | 使用说明                                                                                                                                                                                  |
|:----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `level`         | 日志级别设置。<br>LEVEL_ALL: 所有级别 <br>LEVEL_VERBOSE: 详细输出 <br>LEVEL_DEBUG: 调试级别 <br>LEVEL_INFO: 一般信息。<br>LEVEL_WARNING:警告级别 <br> LEVEL_ERROR: 错误级别 <br> LEVEL_FATAL: 致命级别 <br>LEVEL_NONE: 无输出 |
| `mode`          | Appender模式。<br> 同步模式： 立即保存日志到文件； <br>异步模式： 日志不会立即保存，而是每隔15分钟自动Flush一次。                                                                                                                |
| `logdir`        | 日志保存路径。                                                                                                                                                                               |
| `cachedir`      | 日志缓存路径，当前日志保存的目录。                                                                                                                                                                     |
| `cachedays`     | 缓存日志保存的天数。当前日志先保存在`cachedir`, 达到`cachedays`天数，自动备份到 `logdir`。                                                                                                                         |
| `nameprefix`    | 日志文件的名称前缀。一般日志文件格式为： {名称前缀}_{日期}.xlog                                                                                                                                                 |
| `pubkey`        | 日志压缩使用的公钥。                                                                                                                                                                            |
| `compressmode`  | 压缩模式。包含zlib和zstd两种模式。<br>ZLIB_MODE: zlib模式。<br> ZSTD_MODE: zstd模式。                                                                                                                    |
| `compresslevel` | 压缩级别，在zstd压缩模式下有效，总共1-9九种级别。                                                                                                                                                          |


### 接口说明

| 方法                                                                                       | 说明                        |
|------------------------------------------------------------------------------------------|---------------------------|
| `fromLogConfig(config: XLogConfig): Xlog`                                                | null`                     | 静态方法，用于创建Xlog对象。|
| `setAppenderMode(mode: number): void`                                                    | 设置Appender模式。包括同步方式和异步方式。 |
| `getLogLevel(): number`                                                                  | 获取配置的日志级别。                |
| `appenderFlush(isSync: boolean): void`                                                   | 将缓存内容保存到文件。               |
| `setConsoleLogOpen(isOpen: boolean): void`                                               | 设置同时输出到控制台，默认输出到文件。       |
| `release(): void`                                                                        | 释放用例。                     |
| `logV(tag: string, filename: string, funcname: string, line: number, log: string): void` | 输出Verbose级别日志。            |
| `logI(tag: string, filename: string, funcname: string, line: number, log: string): void` | 输出Info级别日志。               |
| `logD(tag: string, filename: string, funcname: string, line: number, log: string): void` | 输出Debug级别日志。              |
| `logW(tag: string, filename: string, funcname: string, line: number, log: string): void` | 输出Warning级别日志。            |
| `logE(tag: string, filename: string, funcname: string, line: number, log: string): void` | 输出Error级别日志。              |
| `logF(tag: string, filename: string, funcname: string, line: number, log: string): void` | 输出Fatal级别日志。              |

## 约束与限制

在下述版本验证通过：
- DevEco Studio版本: 6.0.0.868, SDK: API18 Release(5.1.0)


## 目录结构

```
ohos_YYEVA/
├── entry/                 # Stage Ability 示例，演示播放、下载等场景
├── library/                # YYEVA ArkTS 引擎库，导出播放器能力
│      └── src/
│           └── main/
│                 └── ets/  
│                      └── EvaAnimConfig.ets            # 解析动画配置
│                          EvaAnimConfigManager.ets     # YYEVA 配置管理器，负责解析和管理动画配置
│                          EvaAnimPlayer.ets            # 播放器
│                          decoder                      # 编解码
│                          file                         # 文件管理
│                          inter                        # 定义动态资源获取和替换功能、设置资源监听
│                          mix                          # 混合动画插件，负责处理混合渲染功能
│                          plugin                       # 动画插件管理器，负责管理所有动画插件
│                          util                         # 各种工具类
│                          view                         #视图类，设置回调
├── AppScope/              # 应用范围配置
├── hvigorfile.ts          # 根级 Hvigor 构建配置
├── oh-package.json5       # ohpm 依赖与项目信息
└── README_zh.md           # 本说明文档
```

`entry` 模块包含两个示例页面：`Eva Demo` 展示播放/暂停/静音/重播等控制，`Eva Download Demo` 演示下载后播放流程。


## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望yyevac库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：

```
-keep
./oh_modules/@ohos/yyevac
```

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_YYEVA/LICENSE ) ，请自由地享受和参与开源。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建。

