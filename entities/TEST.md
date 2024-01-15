## entities 单元测试用例

该测试用例基于OpenHarmony系统下，采用[原库测试用例](https://github.com/fb55/entities) 进行单元测试

**单元测试用例覆盖情况**

### entities

| 接口名                                                        | 是否通过 | 备注 |
|------------------------------------------------------------| ------- | ---- |
| decodeHTML(str: string, mode = DecodingMode.Legacy): string | pass    |      |
| decodeXML(str: string): string                             | pass    |      |
| decodeHTMLStrict(str: string): string                      | pass    |      |
| encodeHTML(data: string): string                           | pass    |      |
| encodeNonAsciiHTML(data: string): string                   | pass    |      |
| encodeXML(str: string): string                             | pass    |      |
| decode(data: string, options: DecodingOptions) : string    | pass     |      |
| encode(data: string, options: EncodingOptions) : string    | pass     |      |
| decodeHTMLAttribute(str: string): string                   | pass    |      |
| escapeUTF8: (data: string) => string                       | pass    |      |
| escapeAttribute: (data: string) => string                  | pass    |      |
| escapeText: (data: string) => string                       | pass    |      |
| isTag(elem: { type: ElementType; }): boolean               | pass    |      |
| isTag(elem: { type: ElementType; }): boolean               | pass    |      |

