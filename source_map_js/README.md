# Source Map JS

## Overview

Source Map JS is a library that generates and uses the source code mapping. It is an information file that stores the location information after code packaging and conversion. It is actually a JSON description file that maintains the code mapping before and after packaging.

## How to Install

```shell
ohpm  install source-map-js@0.6.2
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


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
## Available APIs

1. SourceMapGenerator: Defines the generator for source mapping in an incremental build.
2. SourceMapConsumer: Defines the consumer for source mapping. You can specify a location in the parsed source mapping to query the location in the original file.
3. SourceNode: Define the source node, which is used to abstractly insert and/or join generated JavaScript source code segments while maintaining the association of row and column information between these segments and the original source code.


## Constraints

Source Map JS has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- source_map_js
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                   
````

## How to Contribute

If you find any problem when using Source Map JS, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.
## License

This project is licensed under [BSD-3-Clause License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/source_map_js/LICENSE).
 
    
