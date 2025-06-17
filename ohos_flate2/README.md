# ohos_flate2

## 简介

xxx

![动态]()


## 下载安裝

```
 ohpm install xxx
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用示例
 xxx

## 使用说明
xxx


### 9.关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望ohos_flate2库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/flate2
```



## 接口说明
| class | Name | Parameter | Description |
|-------|------|-----------|-------------|
| xx    | xx   | xxx       | xxx         |

## 约束与限制

在下述版本验证通过：
- DevEco Studio: xxx, SDK: xxx(xx)

## 目录结构

````
/ohos_flate2        # 项目根目录
├── entry      # 示例代码文件夹
├── library    # flate2库文件夹
│    └─ src/main/ets   # 核心代码             
├── README.md     # 安装使用方法    
                   
````

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [Apache-2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_flate2/LICENSE)。
