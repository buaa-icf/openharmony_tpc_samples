# RecyclerViewFlexibleDivid

## 简介
RecyclerViewFlexibleDivid是一款提供数据列表分割线的库


## 使用说明
- 步骤一

将源码下载下来，把library模块引入到自己的项目中

在entry的package.json做如下配置

```
  "dependencies": {
    "recyclerviewflexibledivid": "file:../recyclerviewflexibledivid"
  }
```

 - 步骤二

 ```
 import { DividerLine } from "recyclerviewflexibledivid"
     Column() {
        DividerLine({
          lineLength: 300,
          color: "#FF6699",
          dashed: false,
          dashLength: 3,
          times: 15
        })
      }
```
  

## 约束与限制

在下述版本验证通过：

- DevEco Studio NEXT Developer Beta3: (5.0.3.530), SDK: API12 (5.0.0.35(SP3))

## 目录结构

````
|-----RecyclerViewFlexibleDivid           
|     |-------entry  # 示例代码文件夹 
|          |-----src/main/ets
|               |pages
|                  |---index.ets
|     |---------recyclerviewflexibledivid
|          |-----src/main/ets/components/MainPage
|                  |---DividerLine.ets                 
├── README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/RecyclerViewFlexibleDivid/LICENSE) ，请自由地享受和参与开源。