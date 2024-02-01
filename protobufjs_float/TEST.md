## protobufjs_float单元测试用例

该测试用例基于OpenHarmony系统下，采用[原库测试用例](https://github.com/protobufjs/protobuf.js/tree/master/lib/float/tests/index.js) 进行单元测试

**单元测试用例覆盖情况**

### protobufjs_float

| 接口名                                                            | 是否通过 | 备注 |
|----------------------------------------------------------------| -------- | ---- |
| writeFloatLE(val: number, buf: Uint8Array, pos: number): void  | pass     |      |
| writeFloatBE(val: number, buf: Uint8Array, pos: number): void  | pass     |      |
| readFloatLE(buf: Uint8Array, pos: number): number              | pass     |      |
| readFloatBE(buf: Uint8Array, pos: number): number              | pass     |      |
| writeDoubleLE(val: number, buf: Uint8Array, pos: number): void | pass     |      |
| writeDoubleBE(val: number, buf: Uint8Array, pos: number): void | pass     |      |
| readDoubleLE(buf: Uint8Array, pos: number): number             | pass     |      |
| readDoubleBE(buf: Uint8Array, pos: number): number             | pass     |      |
