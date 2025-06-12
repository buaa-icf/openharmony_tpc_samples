# mime

## 简介

mime库用来获取给定文件路径或扩展名的 mime 类型，为开发者提供更为便利的开发使用体验，代码的可读性更强。

## 安装

```
ohpm install mime
ohpm install @types/mime@3.0.3 --save-dev //import mime 的时候语法报错。其原因是mime包内不含类型声明，需要 @types/mime 下载这个包的声明文件，从而解决语法的报错。
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

```
import mime from "mime";

mime.getType('js'); // application/javascript
mime.getExtension('text/plain')  // txt;
```

## 约束与限制

在下述版本验证通过：

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

DevEco Studio: 4.1 Canary(4.1.3.213), SDK: API11 4.1.2.3

## 目录结构

```
|---- mime
|     |---- entry  # 示例代码文件夹
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建。

## 开源协议

本项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/mime/LICENSE) ，请自由地享受和参与开源。
