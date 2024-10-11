## adler32Demo

### Overview

adler32Demo is a third-party library used to verify the adler-32 checksum algorithm in a JS environment on OpenHarmony.

### How to Install

1. Install adler32Demo.
```
$ ohpm install adler-32
```
2. Import the package.
```
import adler32 from 'adler-32'
```

### Available APIs
| Name| Description|
| :-----| :------|
|`buf(data:number[] or Unit8Array, seed?:number)`|Obtains the checksum value based on the byte array or buffer data.|
|`bstr(data:string,seed?:number)` | Obtains the checksum value based on the binary string (ucs-2 encoded string).|
|`str(data:string, seed?:number)`|Obtains the checksum value based on the standard JS string.|
|`version:string`|Obtains the adler-32 version number.|

For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Adler32Demo/TEST.md).

### Example
For details, see the [Index](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Adler32Demo/entry/src/main/ets/pages/Index.ets) page of the demo project.

For example:
```
  Text(this.strBtn)
    .width('90%')
    .height(50)
    .backgroundColor(0xEEEEEE)
    .borderRadius(15)
    .fontSize(13)
    .textAlign(TextAlign.Center)
    .margin({ top: 10 })
    .onClick(() => {
      let par = "foo bar baz٪☃��";
      let result = adler32.str(par);
      this.message = result + "";
    })
```
### Directory Architecture
```
|-ets
|   |-entryability
|           |-EntryAbility.ts
|   |-pages
|           |-Index.ets             # Homepage demo
```

### Constraints

This project has been verified in the following version:

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API9 Release (3.2.11.9)

### How to Contribute

If you find any problem when using adler32Demo, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

### License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Adler32Demo/LICENSE).
