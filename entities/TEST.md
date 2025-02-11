## entities 单元测试用例

该测试用例基于OpenHarmony系统下，采用[原库测试用例](https://github.com/fb55/entities) 进行单元测试

**单元测试用例覆盖情况**

### entities

| 接口名                                                        | 参数                        |描述                               | 是否通过 | 备注 |
|------------------------------------------------------------|---------------------------|-------------------------------|-----| ---- |
| decodeHTML(str: string, mode = DecodingMode.Legacy): string | str:要解码的字符串 node:解码模式     | 解码HTM                         |pass  |     |
| decodeXML(str: string): string                             | str:要解码的字符串               |解码XML                          | pass |     |
| decodeHTMLStrict(str: string): string                      | str:要解码的字符串               |对HTML字符串进行解码，要求所有实体均以分号结束      | pass |     |
| encodeHTML(data: string): string                           | data:要编码的字符串              |编码HTM                          | pass |     |
| encodeNonAsciiHTML(data: string): string                   | data:要编码的字符串              |对所有非ASCII字符以及在HTML文档中无效的字符进行编码 | pass |     |
| encodeXML(str: string): string                             | str:要编码的字符串               |编码XML                          | pass |     |
| decode(data: string, options: DecodingOptions) : string    | data:要解码的字符串 options:解码选项 |解码带有实体的字符串                     | pass |     |
| encode(data: string, options: EncodingOptions) : string    | data:要编码的字符串 options:编码选项 |编码带有实体的字符串                     | pass |     |
| decodeHTMLAttribute(str: string): string                   | str:要解码的字符串               |解码HTML的属性                      | pass |     |
| escapeUTF8: (data: string) => string                       | data:要处理的字符串              |处理xml中UTF-8编码的转义字符             | pass |     |
| escapeAttribute: (data: string) => string                  | data:要处理的字符串               |转义HTML属性中需要转义的字符               | pass |     |
| escapeText: (data: string) => string                       | data:要处理的字符串               |转义HTML文本中需要转义的字符               | pass |     |
