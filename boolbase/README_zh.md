# boolbase
## 简介

提供两个基本函数，一个始终返回true(trueFunc)，另一个始终返回false(falseFunc)。

## 下载安装
```shell
ohpm install boolbase
```
OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装 OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

### 使用说明

```js
import { falseFunc, trueFunc } from 'boolbase';
@Entry
@Component
struct Index {
    build() {
        RelativeContainer() {
            Column() {
                Text("trueFunc: " + JSON.stringify(trueFunc()))
                .fontSize(20)
                Text("falseFunc: " + JSON.stringify(falseFunc()))
                .fontSize(20)
            }
        }
        .height('100%')
        .width('100%')
    }
}
```
## 接口说明

- 始终返回true

```typescript
    trueFunc()
```
- 始终返回false

```typescript
    falseFunc()
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本: 5.0.1 Release (5.0.5.310), OpenHarmony SDK: 13 (5.0.0(13))
- DevEco Studio 版本: DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16（5.1.0.46）

## 目录结构
```
|----boolbase
|     |---- entry # 示例代码文件夹
|          |----src
|              |----main
|                  |----ets
|                      |----pages
|                          |---- Index.ets
|     |---- README.md  # 安装使用方法 
|     |---- README_zh.md  # 安装使用方法 
```

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然也非常欢迎直接发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [ISC](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/boolbase/LICENSE) ，请自由地享受和参与开源。