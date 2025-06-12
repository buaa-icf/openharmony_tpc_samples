# pvutils


## 简介
本项目是OpenHarmony系统下使用pvutils的示例，pvutils是一组常用的实用程序函数，用于各种Peculiar Ventures基于Javascript的项目库。


## 下载安装

```shell
ohpm install pvutils
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明
```
    //导入pvutils相关接口
    import { toBase64 } from 'pvutils'
    Button("将字符串编码成BASE64格式")
    .onClick((event: ClickEvent) => {
    // aGVsbG8gQkFTRTY0
        this.message = toBase64('hello BASE64');
        console.log(" 将字符串编码成BASE64格式' hello BASE64' ：" + this.message)
    }).margin(5)
```
更多api的使用可参考Index.ets

## 接口说明

| 使用方法                  | 参数                                                      | 相关描述                  |
|-----------------------|---------------------------------------------------------|-----------------------|
| getUTCDate()          | date                                                    | 将本地时间转换为协调世界时（UTC）时间。 |
| getParametersValue()  | parameters, name, defaultValue                          | 获取指定属性值               |
| bufferToHexCodes()    | inputBuffer, inputOffset?, inputLength?, insertSpace?   | ArrayBuffer转16进制字符串   |
| checkBufferParams()   | baseBlock, inputBuffer, inputOffset, inputLength        | buffer参数合法性检测         |
| utilFromBase()        | inputBuffer, inputBase                                  | 2^base 转换为 2^10       |
| utilToBase()          | value, base, reserved?                                  | 2^10 转换为 2^base       |
| utilConcatBuf()       | ...buffers                                              | ArrayBuffer 连接        |
| utilConcatView()      | ...views                                                | Uint8Array 连接         |
| utilDecodeTC()        | 无                                                       | 补码解析                  |
| utilEncodeTC()        | value                                                   | 整数转“补码”               |
| isEqualBuffer()       | inputBuffer1, inputBuffer2                              | ArrayBuffer相等判断       |
| padNumber()           | inputNumber, fullLength                                 | 数字前面添加前导零             |
| toBase64()            | input, useUrlTemplate?, skipPadding?, skipLeadingZeros? | 字符串编码转 BASE64         |
| fromBase64()          | input, useUrlTemplate?, cutTailZeros?                   | BASE64字符串解码成普通字符串。    |
| arrayBufferToString() | buffer                                                  | ArrayBuffer 转字符串。     |
| stringToArrayBuffer() | str                                                     | 字符串转 ArrayBuffer。     |
| nearestPowerOf2()     | length                                                  | 计算最近的2的幂次方            |
| clearProps()          | object, propsArray                                      | 删除指定名称的属性             |


## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

该项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/pvutils/LICENSE) ，请自由地享受和参与开源。