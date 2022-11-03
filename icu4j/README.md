# icu4j

## 简介

 解析字符串，国际化，日期，时间，语言

## 下载安裝

```
 npm install @f-fjs/intl-messageformat-parser
```

OpenHarmony npm环境配置等更多内容，请参考 [如何安装OpenHarmony npm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md) 。

## 使用说明

```
import { parse } from '@f-fjs/intl-messageformat-parser'

const result = parse('On{takenDate,date,short} {name} took {numPhotos,plural, =0 {no photos.}} =1{one photo.} other {# photos}}')

```

## 接口说明
* parse() 解析字符串

## 兼容性

支持 OpenHarmony API version 9 及以上版本。

## 目录结构

````
|-----icu4j           
|     |-------entry  # 示例代码文件夹                   
├── README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/icu4j/LICENSE) ，请自由地享受和参与开源。

