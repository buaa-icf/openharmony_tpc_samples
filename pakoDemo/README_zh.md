# pakoDemo

## 简介

本demo是基于openHarmony系统下使用三方js库[pako](https://github.com/nodeca/pako)，pako提供gzip和deflate等格式压缩解压码功能

## 下载安装

```
  ohpm install pako
  ohpm install @types/pako --save-dev
```
OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

[完整API文档](http://nodeca.github.io/pako/) 
### 1.使用pako处理Uint8Array数据。
```
  import pako from 'pako'

// Deflate
//
const input = new Uint8Array();
//... fill input data here
const output = pako.deflate(input);

// Inflate (simple wrapper can throw exception on broken stream)
//
const compressed = new Uint8Array();
//... fill data to uncompress here
try {
  const result = pako.inflate(compressed);
  // ... continue processing
} catch (err) {
  console.log(err);
}

const deflator = new pako.Deflate();

deflator.push(chunk1, false);
deflator.push(chunk2); // second param is false by default.
...
deflator.push(chunk_last, true); // `true` says this chunk is last

if (deflator.err) {
  console.log(deflator.msg);
}

const output = deflator.result;


const inflator = new pako.Inflate();

inflator.push(chunk1);
inflator.push(chunk2);
...
inflator.push(chunk_last); // no second param because end is auto-detected

if (inflator.err) {
  console.log(inflator.msg);
}

const output = inflator.result;**
```

## 接口说明

|                   方法名                    |          入参          |    接口描述     |
|:----------------------------------------:|:--------------------:|:-----------:|
|           new Deflate(options)           |      options:选项      | 创建Deflate实例 |
|          deflate(data, options)          | data：压缩内容，options：选项 | deflate压缩功能 |
|           gzip(data, options)            | data：压缩内容，options：选项 |  gzip压缩功能   |
|          ungzip(data, options)           | data：解压内容，options：选项 |  gzip解压功能   |
|          inflate(data)           | data：解压内容 |  解压功能   |

## 目录结构

```
/pakoDemo  # 工程代码
|—— entry   # 工程demo示例
│   └── main
│       └── ets
│       └── pages 
│           └── DeflateDemo.ets       # Deflate示例
│           └── Gzip.ets              # Gzip示例  
│           └── Index.ets
│           └── PakoTest.ets          # pako其他接口示例  
```

## 约束与限制
在下述版本验证通过：

DevEco Studio: 5.0 Canary3(5.0.3.228), SDK: API12(5.0.0.18) 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/pakoDemo/LICENSE) ，请自由地享受和参与开源。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎给发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 共建。