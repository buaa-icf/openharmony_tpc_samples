# expr-parser

##  简介
一个方便好用的 js 表达式解析器

## 下载安装
```shell
ohpm install expr-parser
```
OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装 OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

   ```typescript
   import Expression from "expr-parser";
   import hilog from '@ohos.hilog';

   const exprCalc = new Expression('a.value + 12 - (2 * 14 / 4)').parse(); // 传入表达式
   let res = exprCalc({ a: { value: 3 } }); // 传入数据，将结果存在res变量中
   hilog.info(0x0001, "expr-parser TEST:", "result: %{public}d", res); // 打印计算结果 8
   ```

## 接口说明

- 生成公式计算器

```typescript
const exprCalc = new Expression('a.value + 12 - (2 * 14 / 4)').parse();
```

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本：5.0.1 Release，OpenHarmony SDK:API Version 13 Release (5.0.1.115)
- DevEco Studio 版本：DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16(5.1.0.46)

## 目录结构
```
|----exprParser
|    |---- entry
|         |---- src
|              |---- main
|                   |---- ets
|                        |---- pages
|                             |---- Index.ets  # sample示例代码
|              |---- ohosTest  # xts示例代码
|    |---- README.md  # 安装使用方法
|    |---- README_zh.md  # 安装使用方法
```

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) ，当然也非常欢迎直接发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/exprParser/LICENSE) ，请自由地享受和参与开源。