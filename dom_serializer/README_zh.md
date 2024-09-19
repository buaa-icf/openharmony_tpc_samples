# dom-serializer

## 简介

> dom-serializer 是一个可以将DOM节点或DOM节点数组渲染为字符串的工具库。

## 下载安装

```shell
ohpm install dom-serializer
```

OpenHarmony
ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 引用及使用

```
import { render } from "dom-serializer";
import { Document, DomUtils, parseDocument } from "@ohos/htmlparser2";
  let html:string=""
  let dom: Document = parseDocument(html);
  let element = DomUtils.getElementsByTagName('style', dom);
  this.message = render(element)
```

## 接口说明

1. 将DOM节点或DOM节点数组呈现为字符串
   `render(node: AnyNode | ArrayLike<AnyNode>, options?: DomSerializerOptions): string`

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

## 目录结构

````
|---- dom_serializer
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
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志                
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/dom_serializer/LICENSE)，请自由地享受和参与开源。

