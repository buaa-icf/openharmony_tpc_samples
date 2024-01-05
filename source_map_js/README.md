# Source Map JS

## 简介

> 这是一个用于生成和使用这里描述的源映射格式的库。就是一个信息文件，里面存储了代码打包转换后的位置信息，实质是一个 json 描述文件，维护了打包前后的代码映射关系

## 下载安装

```shell
ohpm  install source-map-js@0.6.2
```

OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明


```js
SourceMapGenerator

let map = new sourceMap.SourceMapGenerator({
    file: "source-mapped.js"
});

map.addMapping({
    generated: {
        line: 10,
        column: 35
    },
    source: "foo.js",
    original: {
        line: 33,
        column: 2
    },
    name: "christopher"
});
this.SourceMapGenerator = map.toString()


SourceMapConsumer

class RawSourceMap {
    version: string = '';
    sources: string[]|ESObject;
    names: string[]|ESObject;
    sourcesContent?: string[]
    ;
    mappings: string = '';
}

let testMap: RawSourceMap = {
    version: '3',
    names: ['bar', 'baz', 'n'],
    sources: ['one.js', 'two.js'],
    sourcesContent: ['/the/root'],
    mappings: 'CAAC,IAAI,IAAM,SAAUA,GAClB,OAAOC,IAAID;CCDb,IAAI,IAAM,SAAUE,GAClB,OAAOA'
};
let smc = new sourceMap.SourceMapConsumer(testMap);
this.SourceMapConsumer = smc.hasContentsOfAllSources()

SourceNode
let node = new sourceMap.SourceNode(1, 2, "a.cpp", 'hello world');
node.replaceRight('world', 'universe');
this.SourceNode = node.toString();

```
## 接口说明

1.表示增量构建的源映射:SourceMapGenerator
2.一个解析过的源映射，我们可以通过给它一个生成的源中的文件位置来查询有关原始文件位置的信息:SourceMapConsumer
3.一种对生成的JavaScript源代码片段进行抽象插入和/或连接的方法，同时保持这些片段与原始源代码之间的行和列信息的关联:SourceNode


## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

## 目录结构

````
|---- source_map_js
|     |---- entry  # 示例代码文件夹
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  sample代码
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)
## 开源协议

本项目基于 [BSD-3-Clause License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/source_map_js/LICENSE)
，请自由地享受和参与开源。
    