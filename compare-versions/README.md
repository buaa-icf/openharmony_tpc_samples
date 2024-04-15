# compare_versions

## 简介

compare-versions 是一个用于比较版本号的库，提供了一种简单且可靠的方式来比较两个版本号的大小。这个库支持多种版本号格式，包括数字形式、语义化以及其他常见的格式。通过 compare-versions，开发者可以轻松地确定一个版本号是否大于、等于或小于另一个版本号，从而方便地进行版本管理和控制。

## 安装

```
ohpm install compare_versions
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

```
import { compareVersions, compare, satisfies, validate, validateStrict } from "compare-versions";

compareVersions('11.1.1', '10.0.0'); //  1
compareVersions('10.0.0', '10.0.0'); //  0
compareVersions('10.0.0', '11.1.1'); // -1

compare('10.1.8', '10.0.4', '>');  // true
compare('10.0.1', '10.0.1', '=');  // true
compare('10.1.1', '10.2.2', '<');  // true
compare('10.1.1', '10.2.2', '<='); // true
compare('10.1.1', '10.2.2', '>='); // false

satisfies('10.0.1', '~10.0.0');  // true
satisfies('10.1.0', '~10.0.0');  // false
satisfies('10.1.2', '^10.0.0');  // true
satisfies('11.0.0', '^10.0.0');  // false
satisfies('10.1.8', '>10.0.4');  // true
satisfies('10.0.1', '=10.0.1');  // true
satisfies('10.1.1', '<10.2.2');  // true
satisfies('10.1.1', '<=10.2.2'); // true
satisfies('10.1.1', '>=10.2.2'); // false
satisfies('1.4.6', '1.2.7 || >=1.2.9 <2.0.0'); // true
satisfies('1.2.8', '1.2.7 || >=1.2.9 <2.0.0'); // false
satisfies('1.5.1', '1.2.3 - 2.3.4'); // true
satisfies('2.3.5', '1.2.3 - 2.3.4'); // false

validate('1.0.0-rc.1'); // true
validate('1.0-rc.1');   // false
validate('foo');        // false

validateStrict('11.0.0') // true
```

## 约束与限制

在下述版本验证通过：
DevEco Studio: 4.1 Canary(4.1.3.213), SDK: API11 4.1.2.3

## 目录结构

```
|---- compare-versions
|     |---- entry  # 示例代码文件夹
|     |---- README.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/compare-versions/LICENSE) ，请自由地享受和参与开源。
