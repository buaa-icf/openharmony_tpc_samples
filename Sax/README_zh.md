# sax

## 简介

> sax是一个用于解析 XML或HTML 文档的 JavaScript 库。

## 下载安装

````
ohpm install sax@1.4.1
````

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony har 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

### 解析xml信息

```
  saxParseXml() {
    let _this = this;
    let parser: ESObject = sax.parser(true); // 创建一个新的解析器实例
    parser.onopentag = (node: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', node);
    };
    parser.onclosetag = (nodeName: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', nodeName);
    };
    parser.ontext = (text: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', text);
      _this.message = text
    };
    parser.onend = (ondeEnd: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', ondeEnd);
    };
    parser.onerror = (error: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', error);
    };
    parser.write('<?xml version="1.0" encoding="UTF-8"?> <message> <warning> I\'m an xml! </message>');
    parser.end();
  }
```

### 解析html信息

```
  saxParseHtml() {
    let _this = this;
    let parser: ESObject = sax.parser(true); // 创建一个新的解析器实例
    parser.onopentag = (node: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', node);
    };
    parser.onclosetag = (nodeName: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', nodeName);
    };
    parser.ontext = (text: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', text);
      _this.message = text
    };
    parser.onend = (ondeEnd: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', ondeEnd);
    };
    parser.onerror = (error: ESObject) => {
      hilog.info(0x0000, 'testTag', '%{public}s', error);
    };
    parser.write('<head><b>I\'m an html!</b></head>');
    parser.end();
  }
```

## 接口说明

| **接口**                         | 功能             |
|--------------------------------|----------------|
| parser(a:boolean): Parser      | 创建一个新的解析器实例    |
| onopentag(node: ESObject)      | 开始解析tag标签时回调接口 |
| onclosetag(nodeName: ESObject) | 结束解析tag标签时回调接口 |
| ontext(text: ESObject)         | 解析tag内容回调接口    |
| onend(ondeEnd: ESObject)       | 解析结束回调接口       |
| onerror(error: ESObject)       | 解析出错回调接口       |
| write(str: String)             | 写入解析内容         |
| onattribute(a: ESObject)       | 解析到属性值接口回调     |
| end()                          | 解析器写入结束接口      |
| close()                        | 解析器关闭接口        |

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).

## 目录结构

````
|---- Sax  
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [BSD LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Sax/LICENSE)
，请自由地享受和参与开源。