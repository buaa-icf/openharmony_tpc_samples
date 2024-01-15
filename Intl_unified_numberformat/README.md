# intl_unified_numberformat

## 简介

> intl_unified_numberformat是一个用于实现判断是否支持数字格式化的国际化工具库。


## 下载安装

```shell
ohpm install @f-fjs/intl-unified-numberformat@3.2.1
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

1. 导入依赖库

```typescript
import * as intl_unified_numberformat from '@ohos/intl_unified_numberformat'
```

2. 按需使用相关接口

```typescript
Button('isUnitSupported测试').fontSize(24).onClick(() => {
  let unit:intl_unified_numberformat.Unit = 'degree';
  let supportedResult = intl_unified_numberformat.isUnitSupported(unit);
  if (supportedResult) {
    setData('测试成功', this.dialogController)
  }
})
```

## 接口说明

- 检查Unit是否支持

```typescript
isUnitSupported(unit: Unit)
```

## 约束与限制

在下述版本验证通过：适配DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).

## 目录结构
````
|---- Intl_unified_numberformat  
|     |---- entry  # 示例代码文件夹
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
## 开源协议
本项目基于 [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Intl_unified_numberformat/LICENSE) ，请自由地享受和参与开源。
  

