## protobufjs_path单元测试用例

该测试用例基于OpenHarmony系统下，采用[原库测试用例](https://github.com/protobufjs/protobuf.js/blob/master/lib/path/tests/index.js) 进行单元测试

**单元测试用例覆盖情况**

### protobufjs_path

| 接口名                                                                                   | 是否通过 | 备注 |
|---------------------------------------------------------------------------------------| -------- | ---- |
| isAbsolute(path: string): boolean                                                     | pass     |      |
| normalize(path: string): string                                                       | pass     |      |
| resolve(originPath: string, includePath: string, alreadyNormalized?: boolean): string | pass     |      |
