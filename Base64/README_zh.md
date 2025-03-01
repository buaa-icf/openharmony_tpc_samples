# Base64


## 简介
本项目是OpenHarmony系统下使用Base64的示例，Base64是一个编码和解码工具库。


## 下载安装

```shell
ohpm install Base64
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明
```javascript
    //导入Base64相关接口
    import { btoa, atob } from 'Base64'
    this.message = btoa('hello Base64');
    // aGVsbG8gQmFzZTY0
    console.log("编码 'hello Base64'：" + this.message)
    this.message = atob('aGVsbG8gQmFzZTY0');
    // hello Base64
    console.log("解码 'aGVsbG8gQmFzZTY0'：" + this.message)
```

## 接口说明


| 使用方法    | 参数     | 相关描述              |
|---------|--------|-------------------|
| btoa()  | input  | 编码字符串             |
| atob()  | input  | 解码字符串             |

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望Base64库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/Base64
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317), OpenHarmony SDK:API11 (4.1.0.36)

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

该项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Base64/LICENSE) ，请自由地享受和参与开源。