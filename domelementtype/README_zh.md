# domelementtype

## 简介
> domelementtype 是一个定义htmlparser2库中的所有DOM节点类型的工具库。

## 下载安装
```shell
ohpm install domelementtype 
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明
1. 引入文件及代码依赖
 ```
  import { ElementType, isTag } from 'domelementtype'
 ```

2. 枚举类
 ```
    ElementType.Text
    ElementType.Comment
    ElementType.Directive
    ElementType.CDATA
    ...
    isTag({ type:ElementType.Text})
 ```

## 接口说明

1. 判断一个节点是不是tag

   `isTag(elem: { type: ElementType; }): boolean`

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

- DevEco Studio 版本：DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16（5.1.0.46）。

## 目录结构
````
|---- domelementtype
|     |---- entry  # 示例代码文件夹
|           |---- src
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # 单元测试
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志                  
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/domelementtype/LICENSE)，请自由地享受和参与开源。
