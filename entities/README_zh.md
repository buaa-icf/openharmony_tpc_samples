# entities

## 简介
> entities 快速地编码和解码HTML和XML实体

## 下载安装
```shell
ohpm install entities
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明
1. 引入文件及代码依赖
 ```
  import {
    decode,
    decodeHTML,
    decodeHTMLStrict,
    decodeXML,
    encode,
    encodeHTML,
    encodeNonAsciiHTML,
    encodeXML,
    EntityLevel,
    escapeUTF8,
    decodeHTMLAttribute
} from 'entities';

encode("&#38; ü", EntityLevel.HTML)
encode("&#38; ü")
encodeXML("&#38; ü")
encodeHTML("&#38; ü")
encodeNonAsciiHTML("&#38; ü")
decode("asdf &amp; &#xFF; &#xFC; &apos;", EntityLevel.HTML)
decodeHTMLAttribute("asdf &amp; &#xFF; &#xFC; &apos;")
decode("asdf &amp; &#xFF; &#xFC; &apos;")
decodeXML("asdf &amp; &#xFF; &#xFC; &apos;")
decodeHTML("asdf &amp; &#xFF; &#xFC; &apos;")
decodeHTMLStrict("asdf &amp; &#xFF")
escapeUTF8("(&>)")
escapeAttribute("(&>)")
escapeText("(&>)")
 ```

## 接口说明


1. 解码HTML

   `decodeHTML(str: string, mode = DecodingMode.Legacy): string`
2. 解码XML

   `decodeXML(str: string): string`
3. 对HTML字符串进行解码，要求所有实体均以分号结束。

   `decodeHTMLStrict(str: string): string`
4. 编码HTML

   `encodeHTML(data: string): string`
5. 对所有非ASCII字符以及在HTML文档中无效的字符进行编码

   `encodeNonAsciiHTML(data: string): string`
6. 编码XML

   `encodeXML(str: string): string`
7. 解码带有实体的字符串

   `decode(data: string, options: DecodingOptions | EntityLevel = EntityLevel.XML): string`
8. 编码带有实体的字符串

   `encode(data: string, options: EncodingOptions | EntityLevel = EntityLevel.XML): string`
9. 解码HTML属性

   `decodeHTMLAttribute(str: string): string`
10.  转义xml中UTF-8编码的转义字符

     `escapeUTF8: (data: string) => string`
11. 转义HTML属性中需要转义的字符

    `escapeAttribute: (data: string) => string`
12. 转义HTML文本中需要转义的字符

    `escapeText: (data: string) => string`

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本：4.1 Canary(4.1.3.317)，OpenHarmony SDK:API11 (4.1.0.36)

- DevEco Studio 版本：DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16（5.1.0.46）。

## 目录结构
````
|---- entities
|     |---- entry  # 示例代码文件夹
|           |---- src
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # 单元测试

|     |---- README.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志                   
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/entities/LICENSE)，请自由地享受和参与开源。
