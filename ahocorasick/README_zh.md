# ahocorasick 

## 简介

本库是OpenHarmony系统下基于[ahocorasick](https://github.com/BrunoRB/ahocorasick)库使用的开发示例，ahocorasick库是Aho-Corasick字符串搜索算法的实现，能够高效的进行字符串匹配。

## 安装

```
ohpm install ahocorasick
```

## 使用说明

注意事项：构造AhoCorasick搜索算法时，不允许传入空值，构造前需对关键字及原始段落内容进行判空操作

```
// @ts-ignore
import AhoCorasick from 'ahocorasick'
var ac = new AhoCorasick(['keyword1', 'keyword2', 'etc']);
var results = ac.search('should find keyword1 at position 19 and keyword2 at position 47.');
```

```
运行结果：[ [ 19, [ 'keyword1' ] ], [ 47, [ 'keyword2' ] ] ]
```

## 接口说明

```
  let aho:AhoCorasick = new AhoCorasick([keyWords]);
```
| **接口**                   | 参数         | 功能                                           |
|--------------------------|------------| ---------------------------------------------- |
| aho.search(text: string) | text：搜索的内容 | 用于在文本中搜索多个关键词的函数，返回一个列表，其中包含在文本中找到的每个关键词的结束索引和关键词本身。如果没有找到任何匹配项，则返回空列表。                               |



## 约束与限制
在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## 目录结构
```
|---- ahocorasick  
|     |---- entry  # 示例代码文件夹
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法                     
```

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0 ](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ahocorasick/LICENSE) ，请自由地享受和参与开源。