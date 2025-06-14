# @protobufjs/aspromise

## 简介
> @protobufjs/aspromise 是一个可以从Node风格的回调函数中返回一个Promise的工具库。

## 下载安装
```shell
ohpm install @protobufjs/aspromise
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 引用及使用
```
import { asPromise } from '@protobufjs/aspromise'

      let ctx: ESObject = {};
      let promise: Promise<ESObject> = asPromise(fn, ctx, 1, 2);
      promise.then((arg2: ESObject) => {
          result += "function should be resolved with arg2 = " + arg2
          that.message = result
      }).catch((err: ESObject) => {
          result += "function should not be rejected (" + err + ")"
          that.message = result
      });
        
        
      fn(error: Error | null, param1: ESObject, callback: Function) {
          result += "function should be called with this = ctx\r\n"
          result += "function should be called with arg1 = " + error + "\r\n"
          result += "function should be called with arg2 = " + param1 + "\r\n"
          callback(null, param1)
          callback(error)
          class test {}
          return new test()
      }

```

## 接口说明
1. 返回一个promise
   `asPromise(fn: asPromiseCallback, ctx: any, ...params: any[]): Promise<any>`

## 约束与限制
在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

## 目录结构
````
|---- protobufjs_aspromise
|     |---- entry  # 示例代码文件夹
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # 单元测试

|     |---- README.md  # 安装使用方法        
|     |---- README_zh.md  # 安装使用方法              
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建。

## 开源协议
本项目基于 [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobufjs_aspromise/LICENSE) ，请自由地享受和参与开源。

