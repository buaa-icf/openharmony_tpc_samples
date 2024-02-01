## protobufjs_utf8 单元测试用例

该测试用例基于OpenHarmony系统下，采用[原库测试用例](https://github.com/protobufjs/protobuf.js/tree/master/lib/utf8/tests/index.js) 进行单元测试

**单元测试用例覆盖情况**

### protobufjs_utf8

| 接口名                                                               | 是否通过 | 备注 |
|-------------------------------------------------------------------| -------- | ---- |
| length(string: string): number                                    | pass     |      |
| read(buffer: Uint8Array, start: number, end: number): string      | pass     |      |
| write(string: string, buffer: Uint8Array, offset: number): number | pass     |      |

