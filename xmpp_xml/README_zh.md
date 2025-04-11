# @xmpp/client

## 简介

[@xmpp/xml][xmpp.js/packages/xml at main · xmppjs/xmpp.js (github.com)](https://github.com/xmppjs/xmpp.js/tree/main/packages/xml) @xmpp/xml 是一个专注于处理XMPP协议的XML解析库。

## 已支持功能

- 创建xml元素
- 解析XML字符串
- 含有特殊字符XML字符串进行转义
- 将转义后的XML字符串进行反转义
- 将XML文本中的特殊字符进行转义
- 将转义后的XML文本进行反转义

## 下载安装

```
 ohpm install @ohos/xmpp_xml
```

## 接口和属性列表

接口列表

| **接口**                    | 参数                  | 功能                                                         |
| --------------------------- | --------------------- | ------------------------------------------------------------ |
| onStartElement(name, attrs) | name，attrs           | 创建了一个新的 `Element` 实例，并根据当前的解析状态将其添加到正确的位置 |
| onEndElement(name)          | 'name':string         | 当解析器遇到 XML 结束标签时调用的方法。在该方法中，检查当前的解析状态，处理结束标签 |
| onText(str)                 | 'online':string       | 当解析器遇到文本内容时调用的方法。在该方法中，将文本内容添加到当前的 `cursor` 元素中 |
| end(data)                   | 'status':string       | 结束解析，如果有剩余的数据，继续解析。                       |
| write(data)                 | 'stanza':string       | 将数据传递给 `LtxParser` 实例进行解析                        |
| xml(...args)                | args用于构建xml的数据 | 这是一个默认导出的函数，接受任意参数并返回一个通过`createElement()`函数创建的XML元素。可以用于快速创建XML元素 |
| createElement               | 无                    | 用于创建一个XML元素，可以传入标签名、属性、子元素等信息，返回一个新的`Element`实例。 |
| escapeXML                   | 无                    | 用于将XML字符串中的特殊字符进行转义                          |
| unescapeXML                 | 无                    | 用于将转义后的XML字符串进行反转义，还原特殊字符              |
| escapeXMLText               | 无                    | 用于将XML文本中的特殊字符进行转义                            |
| unescapeXMLText             | 无                    | 用于将转义后的XML文本进行反转义，还原特殊字符                |



## 使用示例

```
import {Parser} from '@ohos/xmpp_xml'
import xml  from "@ohos/xmpp_xml"
@Entry
@Component
struct Index {
  private parser:ESObject =new Parser();
  build() {
    Column() {
      Button('Parser').onClick((v) => {
          //解析开始标签
        this.parser.on('start', (element:ESObject) => {
          console.info('Parser---Start element:', element);
        });
          //解析结束标签
        this. parser.on('end', (root:ESObject) => {
          console.info('Parser---End element:', root);
        });
          //解析值
        this. parser.on('element', (element:ESObject) => {
          console.info('Parser---Element:', element);
        });
          //写入一个XML字符串，触发解析过程。
        this.parser.write("<foo><bar>hello</bar></foo>");
      }).margin({ top: px2vp(50) })
        //创建xml实体
         message= xml("message", { type: "chat", to: "admin@10.50.80.51" }, xml("body", {}, "你好")).toString();
          })
    }
    .height('100%')
    .width('100%')
  }
```

## 使用说明

#### 当解析器遇到 XML 开始标签时调用的方法

```
parser.onStartElement('message', { from: 'sender@example.com', to: 'receiver@example.com' });
```

#### 当解析器遇到 XML 结束标签时调用的方法。

```
parser.onEndElement('message');
```

#### 当解析器遇到文本内容时调用的方法

```
parser.onText('Hello, world!');
```

#### 将数据传递给 `LtxParser` 实例进行解析

xmpp.send(xml)

```
parser.write('<message from="sender@example.com" to="receiver@example.com">Hello, world!</message>');
```

#### 结束解析，如果有剩余的数据，继续解析

```
parser.end();
```

#### 监听Parser方法

```
parser.on('start', (element) => {
  console.log('Start element:', element);
});

parser.on('end', (root) => {
  console.log('End element:', root);
});

parser.on('element', (element) => {
  console.log('Element:', element);
});

parser.on('error', (error) => {
  console.error('Error:', error.message);
});
```
## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望三方库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_xml
```
在下述版本验证通过：
DevEco Studio:5.0.3.200, 5.0.0.22-Canary2, SDK: API12

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。