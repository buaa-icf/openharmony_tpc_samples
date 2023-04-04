# ahocorasick 

## 简介

本库是Aho-Corasick字符串搜索算法的实现，能够高效的进行字符串匹配。

## 安装

```
`npm install ahocorasick --save`
```
OpenHarmony npm环境配置等更多内容，请参考 [如何安装OpenHarmony npm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md) 。

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

## 兼容性
- [DevEco Studio](https://developer.harmonyos.com/cn/develop/deveco-studio#download) 版本：DevEco Studio 3.1 Beta1及以上版本。
- OpenHarmony SDK版本：API version 9 及以上版本。

## 目录结构
````
|---- ahocorasick  
|     |---- entry  # 示例代码文件夹
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ahocorasick/LICENSE) ，请自由地享受和参与开源。