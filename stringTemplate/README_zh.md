# ohos/stringtemplate

## 介绍
stringtemplate是一个用于文本生成的模板引擎,它可以将文本模板与数据合并以生成最终的文本输出。

## 下载安装

```shell
ohpm install @ohos/stringtemplate
```
- OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 编译st文件或文件夹

```typescript
import { Stc } from '@ohos/stringtemplate';
  
let path = '/dir/test.st'; // path为要编译文件的完整路径 或为要编译文件夹的完整路径 
let stc = new Stc();
// 支持的开始和结束分隔符: #$%^&*<> 默认的开始和结束分隔符都为 $
// stc.statDelimiters = '<'; // 设置编译文件开始分割符
// stc.endDelimiters = '>';  // 设置编译文件结束分割符
stc.compile(path);
// 编译结束后会在传入的文件相同路径下生成（模版名_stg.js）文件
```

1. 从"@ohos/stringtemplate"导入Stc。
2. 初始化一个新的Stc对象stc。
3. 调用stc.compile(path)函数，并传入要编译文件或文件夹完整路径。

### 文本模版与数据合并
```typescript
// 使用processTemplate接口
import { Stc, ProcessTemplate } from '@ohos/stringtemplate';
import getInstance from '../xxx/introduce_stg'; // 从上一步编译好的xxxstg_js文件导入

let p = new ProcessTemplate();
let data = new Object({ name: "LiHua", like: "Orange" });
let templateName = 'introduce'; // 模版名称和.st文件内模版名称一致
let res: string = p.processTemplate(getInstance, data, templateName); // res即为模版和数据结合的最终文本
```

```typescript
// 使用loadGroup接口
import { st } from '@ohos/stringtemplate';
import getInstance from '../xxx/introduce_stg'; // 从上一步编译好的xxxstg_js文件导入
  
let p = new ProcessTemplate();
let data = new Object({ name: "LiHua", like: "Orange" });
let templateName = 'introduce'; // 模版名称和.st文件内模版名称一致
let res: string = st.loadGroup(getInstance).render(templateName, data); // res即为模版和数据结合的最终文本
```

## 接口说明

| 接口                            | 参数                                                             | 参数说明          | 返回值         | 接口说明             |
|-------------------------------|----------------------------------------------------------------|---------------|-------------|------------------|
| Stc.compile                   | path:string                                                    | 需编译文件或文件夹完整路径 | 无           | 编译模版文件或文件夹       |
| ProcessTemplate.processTemplate | getInstance:Function, data: object, templateName: string | getInstance：编译好的模版函数,data：填充模版的数据,templateName：模版名称 | 模版和数据结合的字符串 | 将模版和数据结合生成最终的字符串 |
| st.loadGroup                  | getInstance:Function  | getInstance：编译好的模版函数 | 模版和数据结合的字符串 | 将模版和数据结合生成最终的字符串 |
## 注意事项
- 编译文件需传入文件完成路径:**文件路径**+**文件名**

## 约束与限制
在下述版本验证通过：

DevEco Studio: 5.0.1 Release, SDK: API Version 13 Release (5.0.1.115)

## 目录结构
````
|----ohos_minizip  
|     |---- entry  # 示例代码文件夹
|     |---- library  
|                |---- stringTemplate # stringTemplate-js实现代码
|                      |---- bin
|                            |---- stcFile # 编译文件的入口逻辑代码
|                            |---- ststFile # 模版和数据结合的入口逻辑代码
|                      |---- compile  # 编译文件的逻辑代码
|                      |---- lib # 模版和数据结合的逻辑代码
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法   
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [BSD-3-Clause License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/stringTemplate/LICENSE) ，请自由地享受和参与开源。 
    



